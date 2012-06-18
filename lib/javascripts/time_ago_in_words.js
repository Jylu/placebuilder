window.timeAgo = function(date_str) {
  return timeAgoConstructor(date_str, []);
};

window.timeAgoNamedDays = function(date_str) {
  return timeAgoConstructor(date_str, ["named_days"]);
};

window.timeAgoMonths = function(date_str) {
  return timeAgoConstructor(date_str, ["months"]);
};

window.timeAgoThisWeekThenMonths = function(date_str) {
  return timeAgoConstructor(date_str, ["this_week", "months"]);
};

window.timeAgoInWords = function(date_str) {
  return timeAgoConstructor(date_str, ["inWords", "deprecated"]);
};

window.timeAgoConstructor = function(date_str, params) {
  var time = parseISOTime(date_str);
  var time_obj = new Date(time);
  var diff_in_seconds = (time - (new Date)) / 1000;
  var diff_in_minutes = Math.abs(Math.floor((diff_in_seconds / 60)));
  var future = diff_in_seconds > 0;
  var add_token = function (in_words) { return future ? "in " + in_words : in_words + " ago"; };
  var of_type = function (param) { return $.inArray(param, params) != -1; };

  if (of_type("deprecated")) { alert("The timeAgoInWords() function is deprecated, please stop using it. You can find it in /lib/javascripts/time_ago_in_words.js.\n\nIf you are a Common Place neighbor, not a developer -- oops! We're sorry. Please let us know about this so we can fix it right away!"); };

  if (of_type("this_week")) {
    // week branch merges back into main branch if not matched
    if (!(timeAgoNamedDaysHelper(time, future) === false)) { return 'this week'; }
  };
  if (of_type("months")) { return timeAgoMonthsHelper(time_obj, future); }
  if (diff_in_minutes === 0) { return add_token('less than a minute'); }
  if (diff_in_minutes == 1) { return add_token('a minute'); }
  if (diff_in_minutes < 60) { return add_token(diff_in_minutes + ' minutes'); }
  if (diff_in_minutes < 60*2) { return add_token('1 hour'); }
  if (diff_in_minutes < 60*24) { return add_token(Math.floor(diff_in_minutes / 60) + ' hours'); }
  if (of_type("named_days")) {
    // named_days branch merges back into main branch if not matched
    var named_days = timeAgoNamedDaysHelper(time, future);
    if (!(named_days === false)) { return named_days; }
  };
  if (of_type("inWords")) { return add_token(timeAgoInWordsHelper(diff_in_minutes)); }
  if (of_type("by_end_of_week")) { return "week ending " + displayDate(new Date(time + ((6 - time_obj.getDay()) * 24*60*60*1000))); }
  return displayDate(time_obj);
};

window.timeAgoMonthsHelper = function(time_obj, future) {
  var month = time_obj.getMonth();
  if (isCurrentYear(time_obj)) {
    return month == (new Date).getMonth() ? "this month" : wordForMonth(month);
  };
  return wordForMonth(month) + " " + time_obj.getFullYear();
};

window.timeAgoNamedDaysHelper = function(time, future) {
  var modded_date = new Date(modDate(time));
  var modded_current_date = new Date(modDate((new Date).getTime()));
  // round diff in days in case of daylight savings time
  diff_in_days = Math.abs(Math.round((modded_date.getTime() - modded_current_date.getTime()) / (24*60*60*1000)));
  if (diff_in_days < 2) { return future ? 'tomorrow' : 'yesterday'; }
  var add_day_name_token = function (day) { return future ? "this " + day : day; };
  if (diff_in_days < 7) { return add_day_name_token(wordForDay(modded_date.getDay())); }
  return false;
};

window.timeAgoInWordsHelper = function(diff_in_minutes) {
  if (diff_in_minutes < 1440*2) { return '1 day'; }
  if (diff_in_minutes < 1440*7) { return Math.floor(diff_in_minutes / 1440) + ' days'; }
  if (diff_in_minutes < 10080*2) { return '1 week'; }
  if (diff_in_minutes < 10080*4) { return Math.floor(diff_in_minutes / 10080) + ' weeks'; }
  if (diff_in_minutes < 1440*30*2) { return '1 month'; }
  if (diff_in_minutes < 1440*365.25) { return Math.floor(diff_in_minutes / 43200) + ' months'; }
  if (diff_in_minutes < 525960*2) { return '1 year'; }
  return Math.floor(diff_in_minutes / 525960) + ' years';
};

window.parseISOTime = function(date_str) {
  var m = date_str.match(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z/);
  return Date.UTC(m[1],m[2] - 1,m[3],m[4],m[5],m[6]);
};

window.modDate = function(utc_time) {
  // get local y/m/d
  var time = new Date(utc_time);
  var yyyy = time.getFullYear();
  var mm = time.getMonth();
  var dd = time.getDate();
  
  // make utc date object with local y/m/d; adjust local time to true utc time
  var offsetDate = Date.UTC(yyyy, mm, dd);
  var localOffset = time.getTimezoneOffset() * 60*1000;
  return offsetDate + localOffset;
};

window.wordForDay = function(day_numb) {
  switch (day_numb) {
    case 0: return 'Sunday';
    case 1: return 'Monday';
    case 2: return 'Tuesday';
    case 3: return 'Wednesday';
    case 4: return 'Thursday';
    case 5: return 'Friday';
    case 6: return 'Saturday';
    default: {
      alert("Something went wrong in /lib/javascripts/time_ago_in_words.js");
      return false;
    }
  };
};

window.wordForMonth = function(month_numb) {
  switch (month_numb) {
    case 0: return 'January';
    case 1: return 'February';
    case 2: return 'March';
    case 3: return 'April';
    case 4: return 'May';
    case 5: return 'June';
    case 6: return 'July';
    case 7: return 'August';
    case 8: return 'September';
    case 9: return 'October';
    case 10: return 'November';
    case 11: return 'December';
    default: {
      alert("Something went wrong in /lib/javascripts/time_ago_in_words.js");
      return false;
    }
  };
};

window.isCurrentYear = function(date) {
  return date.getFullYear() == (new Date).getFullYear()
};

window.displayDateWithoutYear = function(date) {
  var month = wordForMonth(date.getMonth());
  var day = date.getDate();
  return month + " " + day;
};

window.displayDateWithYear = function(date) {
  var year = date.getFullYear();
  return displayDateWithoutYear(date) + ", " + year;
};

window.displayDate = function(date) {
  return isCurrentYear(date) ? displayDateWithoutYear(date) : displayDateWithYear(date);
};
