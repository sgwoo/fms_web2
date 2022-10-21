


	/* ��¥ selet box */
	var fixed_year = 0;
	var fixed_month = 0;
	var fixed_day = 0;

	var curr_year = 0;
	var curr_month = 0;
	var curr_day = 0;

	var selName = null;
	var day_all = new Array(31);
	var dateMont = new Array(12);

	var cnt = 0;


	function init(count) {
		fixed_year = 0;
		fixed_month = 0;
		fixed_day = 0;

		cnt = count;

		curr_year = parseInt(((new Date()).toString()).substring(28));
		curr_month = parseInt(((new Date()).getMonth())) + 1;
		curr_day = parseInt(((new Date()).getDate()));
	}
	
	function init3(count) {
		fixed_year = 0;
		fixed_month = 0;
		fixed_day = 0;

		cnt = count;

		curr_year = parseInt(((new Date()).toString()).substring(28))+1;
		curr_month = parseInt(((new Date()).getMonth())) + 1;
		curr_day = parseInt(((new Date()).getDate()));
	}

	function init2(count, year, month, day) {
		fixed_year = 0;
		fixed_month = 0;
		fixed_day = 0;

		cnt = count;

		curr_year = year;
		curr_month = month;
		curr_day = day;
	}

	function init_display(name) {

		fixed_year = curr_year;
		fixed_month = curr_month;
		fixed_day = curr_day;

		selName = name;
		getSelectYear();
		getSelectMonth(curr_year);
		day_all = getMonthDate(curr_year, curr_month);
		getSelectDay1(day_all);
	}
	
	function init_display2(name) {

		fixed_year = curr_year;
		fixed_month = curr_month;
		fixed_day = curr_day;
                
		selName = name;
		getSelectYear2();
		getSelectMonth(curr_year);
		day_all = getMonthDate(curr_year, curr_month);
		getSelectDay(day_all);
	}
	
	function init_display3(name) {

		fixed_year = curr_year;
		fixed_month = curr_month;
		fixed_day = curr_day;

		selName = name;
		getSelectYear3();
		//getSelectMonth(curr_year);
		//day_all = getMonthDate(curr_year, curr_month);
		//getSelectDay(day_all);
	}
	
	function init_display4(name) {

		fixed_year = curr_year;
		fixed_month = curr_month;
		fixed_day = curr_day;

		selName = name;
		getSelectYear();
		getSelectMonth(curr_year);
		day_all = getMonthDate(curr_year, curr_month);
		getSelectDay(day_all);
	}
	
	function checkEmbolism(year) {

		var remain = 0;
		var remain_1 = 0;
		var remain_2 = 0;

		remain = year % 4;
		remain_1 = year % 100;
		remain_2 = year % 400;

		// the ramain is 0 when year is divided by 4;
		if (remain == 0) {

			// the ramain is 0 when year is divided by 100;
			if (remain_1 == 0) {

				// the remain is 0 when year is divided by 400;
				if (remain_2 == 0) return true;
				else return false;

			 } else  return true;
		}
		return false;
	}		

	function getMonthDate(year, month) {

		dateMonth = new Array(12);
		var days = new Array(31);
		
		dateMonth[0] = 31;
		dateMonth[1] = 28;
		dateMonth[2] = 31;
		dateMonth[3] = 30;
		dateMonth[4] = 31;
		dateMonth[5] = 30;
		dateMonth[6] = 31;
		dateMonth[7] = 31;
		dateMonth[8] = 30;
		dateMonth[9] = 31;
		dateMonth[10] = 30;
		dateMonth[11] = 31;

		if (checkEmbolism(year)) { dateMonth[1] = 29; }

		for (k = 0; k < dateMonth[month - 1]; k++) {
			days[k] = (k + 1);
		}

		return days;
	}

	function getMonthDateCnt(year, month) {

		dateMonth = new Array(12);
		var days = new Array(31);
		
		dateMonth[0] = 31;
		dateMonth[1] = 28;
		dateMonth[2] = 31;
		dateMonth[3] = 30;
		dateMonth[4] = 31;
		dateMonth[5] = 30;
		dateMonth[6] = 31;
		dateMonth[7] = 31;
		dateMonth[8] = 30;
		dateMonth[9] = 31;
		dateMonth[10] = 30;
		dateMonth[11] = 31;

		if (checkEmbolism(year)) { dateMonth[1] = 29; }

		return dateMonth[month - 1];
	}
	
	function getMonth(selector) {

		fixed_year = selector.value;
		return;
	}

	function setDate(yr_sel, month_sel, day_sel) {

		fixed_year = yr_sel.value;
		fixed_month = month_sel.value;
		fixed_day = day_sel.value;
		day_all = getMonthDate(fixed_year, fixed_month);

		getDays(day_all, day_sel);
	}

	function getDays(day_all, day_sel) {

		selName = selName + "_day";

		for (var i = day_sel.length; i > 0; i--){
			day_sel.options[i] = null;
		}

		for(var i = 0; i < dateMonth[fixed_month - 1]; i++){
			var opt = new Option();
		 	opt.text = day_all[i];
			opt.value = ChangeNum(day_all[i]);
			day_sel.options[i] = opt;
		}
		init();
	}
	
	function getSelectYear3() {

		document.writeln("<select name=" + selName + ">");
		for (i = -(cnt); i < (cnt + 1); i++) {
			var dis_year = null;
			dis_year = "<option value=" + (curr_year + i);
			if ((curr_year + i) == fixed_year) dis_year = dis_year + " selected";
			dis_year = dis_year + ">" + (curr_year + i) + "</option>";
			document.writeln("   " + dis_year);
		}
		document.writeln("</select><font size=2>�� </font>");
	}
	
	function getSelectYear() {

		document.writeln("<select name=" + selName + "_yr onChange=\"setDate(this.form." + selName + "_yr, this.form." +
									selName + "_mth, this.form." +
									selName + "_day);\">");
		for (i = -(cnt); i < (cnt + 1); i++) {
			var dis_year = null;
			dis_year = "<option value=" + (curr_year + i);
			if ((curr_year + i) == fixed_year) dis_year = dis_year + " selected";
			dis_year = dis_year + ">" + (curr_year + i) + "</option>";
			document.writeln("   " + dis_year);
		}
		document.writeln("</select><font size=2>�� </font>");
	}
	function getSelectYear2() {

		document.writeln("<select name=" + selName + "_yr onChange=\"setDate(this.form." + selName + "_yr, this.form." +
									selName + "_mth, this.form." +
									selName + "_day);\">");
		for (i = -(cnt); i < 1; i++) {
			var dis_year = null;
			dis_year = "<option value=" + (curr_year + i);
			if ((curr_year + i) == fixed_year) dis_year = dis_year + " selected";
			dis_year = dis_year + ">" + (curr_year + i) + "</option>";
			document.writeln("   " + dis_year);
		}
		document.writeln("</select><font size=2>�� </font>");
	}

	function getSelectMonth() {

		document.writeln("<select name=" + selName + "_mth onChange=\"setDate(this.form." + selName + "_yr, this.form." +
									selName + "_mth, this.form." +
									selName + "_day);\">");

		for (i = 1; i < 13; i++) {
			mon = null;
			iValue = ChangeNum(i);
			mon = "<option value=" + iValue;
			if ((curr_year == fixed_year) && (i == fixed_month)) mon = mon + " selected";
			mon = mon + ">" + i + "</option>";
			document.writeln("   " + mon);
		}

		document.writeln("</select><font size=2>�� </font>");
	}

	function getSelectDay(day_all) {

		document.writeln("<select name=" + selName + "_day onChange=\"\">");

		for (i = 0; i < dateMonth[curr_month - 1]; i++) {
			day = null;
			iValue = ChangeNum(i+1);
			day = "<option value=" + iValue;
			if ((curr_year == fixed_year) && (curr_month == fixed_month) && ((i + 1) == fixed_day)) day = day + " selected";
			day = day + ">" + (i + 1) + "</option>";
			document.writeln("   " + day);
		}
		document.writeln("</select><font size=2>��</font>");
		init();
	}
	
	function getSelectDay1(day_all) {

		document.writeln("<select name=" + selName + "_day onChange=\"javascript:ChangeTestDT()\">");

		for (i = 0; i < dateMonth[curr_month - 1]; i++) {
			day = null;
			iValue = ChangeNum(i+1);
			day = "<option value=" + iValue;
			if ((curr_year == fixed_year) && (curr_month == fixed_month) && ((i + 1) == fixed_day)) day = day + " selected";
			day = day + ">" + (i + 1) + "</option>";
			document.writeln("   " + day);
		}
		document.writeln("</select><font size=2>��</font>");
		init();
	}
		
/* ����������, �˻���ȿ�Ⱓ, ������ȿ�Ⱓ */
function CheckDate()
{
	var fm = document.form1;
	var init_reg_dt = "";
	var reg_dt = "";
	var reg_year = "";
	var reg_month = "";
	var reg_day = "";
	var car_end_dt = "";
	var end_dt;
	var test_dt;
	
	if(fm.car_kd.value=='')
	{
		alert("������ �����Ͻʽÿ�");
		fm.car_kd.focus();
		return;
	}else if(fm.car_kd.value==2){
		end_dt = 5;
		test_dt = 4;
	}else if(fm.car_kd.value==3){
		end_dt = 4;
		test_dt = 4;
	}else{
		end_dt = 8;
		if(fm.car_kd.value==1)
		{
			test_dt = 4;
		}else{
			test_dt = 5;
		}
	}
	
	init_reg_dt = fm.init_reg_dt.value;
	if(init_reg_dt=='')
	{
		alert("���ʵ������ �Է��Ͻʽÿ�");
		fm.init_reg_dt.focus();
		return;
	}
	
	reg_dt = replaceString("-","",init_reg_dt);
	if(reg_dt.length!=8)
	{
		alert('��¥�� ������ "2002-01-23" �Ǵ� "200020123" �Դϴ�.');
		fm.init_reg_dt.focus();
		return;
	}
	reg_year = parseInt(reg_dt.substring(0,4), 10);
	reg_month = parseInt(reg_dt.substring(4,6), 10);
	reg_day = parseInt(reg_dt.substring(6,8),10);

	/* ���ɸ����� */
	if(reg_day==1)
	{
		if(reg_month==1)
		{
			var end_year = reg_year+end_dt-1;
			var end_month = 12;
			var end_day = getDaysInMonth(end_year,end_month);
		}else{
			var end_year = reg_year+end_dt;
			var end_month = ChangeNum(reg_month-1);
			var end_day = getDaysInMonth(end_year,end_month);
		}
	}else{
		var end_year = reg_year+end_dt;
		var end_month = ChangeNum(reg_month);
		var end_day = ChangeNum(reg_day-1);
	}
	fm.car_end_dt.value = end_year + "-" + end_month + "-" + end_day;
	
	/*�˻���ȿ�Ⱓ*/
	fm.maint_st_dt.value = ChangeDate(init_reg_dt);
	/*maint_year = reg_year+2;
	maint_month = ChangeNum(reg_month);
	maint_day = getDaysInMonth(maint_year,maint_month);
	fm.maint_end_dt.value = maint_year + "-" + maint_month + "-" + maint_day;
	*/
	/*������ȿ�Ⱓ*/
	fm.test_st_dt.value = ChangeDate(init_reg_dt);
	/*test_year = reg_year+test_dt;
	test_month = ChangeNum(reg_month);
	test_day = getDaysInMonth(test_year,test_month);
	fm.test_end_dt.value = test_year + "-" + test_month + "-" + test_day;
*/
	parent.nodisplay.location ='./i_null.jsp?reg_date=' + init_reg_dt +"&test_dt="+ test_dt;		

	fm.init_reg_dt.value = ChangeDate(init_reg_dt);
	
}


/* Date ������ ��ȭ��Ų��.. (��)20030101->2003-01-01*/
function ChangeDate(arg)
{
	ch_date = replaceString("-","",arg);
	if(ch_date!="")
	{
	if(ch_date.length!=8)
	{
		alert('��¥�� ������ "2002-01-23" �Ǵ� "200020123" �Դϴ�.');
//		return arg;
		return "";
	}
	ch_year = parseInt(ch_date.substring(0,4),10);
	ch_month = parseInt(ch_date.substring(4,6),10);
	ch_day = parseInt(ch_date.substring(6,8),10);
	if(isNaN(ch_date))
	{
		alert("���ڿ� '-' ���� �Է°����մϴ�.");
//		return arg;
		return "";
	}
	if(!(ch_month>0 && ch_month<13))
	{
		alert("���� 01 - 12 ������ �Է� �����մϴ�.");
//		return arg;
		return "";
	}
	ck_day = getDaysInMonth(ch_year,ChangeNum(ch_month))
	if(ck_day<ch_day)
	{
		alert("���� 01 - " + ck_day + " ������ �Է� �����մϴ�.");
//		return arg;
		return "";
	}
		
	return ch_year + "-" + ChangeNum(ch_month) + "-" + ChangeNum(ch_day);
	}else{
	return "";
	}

}

/* Date ������ ��ȭ��Ų��.. (��)20030101->2003-01-01*/
function ChangeDate2(arg)
{
	var ch_date = replaceString("-","",arg);

	if(ch_date!="")
	{
	if(ch_date.length!=8)
	{
		alert('��¥�� ������ "2002-01-23" �Ǵ� "200020123" �Դϴ�.');
		return "";
	}
	ch_year = parseInt(ch_date.substring(0,4),10);
	ch_month = parseInt(ch_date.substring(4,6),10);
	ch_day = parseInt(ch_date.substring(6,8),10);
	if(isNaN(ch_date))
	{
		alert("���ڿ� '-' ���� �Է°����մϴ�.");
		return "";
	}
	if(!(ch_month>0 && ch_month<13))
	{
		alert("���� 01 - 12 ������ �Է� �����մϴ�.");
		return "";
	}
	ck_day = getDaysInMonth(ch_year,ChangeNum(ch_month))
	if(ck_day<ch_day)
	{
		alert("���� 01 - " + ck_day + " ������ �Է� �����մϴ�.");
		return "";
	}
		
	return ch_year + "-" + ChangeNum(ch_month) + "-" + ChangeNum(ch_day);
	}else{
	return "";
	}

}

/* Date ������ ��ȭ��Ų��.. (��¥ �˻��� '-' ���̱�)*/
function ChangeDate3(arg)
{
	ch_date = replaceString("-","",arg);

	if(ch_date!="")
	{
		if(ch_date.length==4){
			ch_year = parseInt(ch_date.substring(0,4),10);
			return ch_year;
		}else if(ch_date.length == 6){
			ch_year = parseInt(ch_date.substring(0,4),10);
			ch_month = parseInt(ch_date.substring(4,6),10);
			return ch_year + "-" + ChangeNum(ch_month);
		}else if(ch_date.length == 8){
			ch_year = parseInt(ch_date.substring(0,4),10);
			ch_month = parseInt(ch_date.substring(4,6),10);
			ch_day = parseInt(ch_date.substring(6,8),10);
			return ch_year + "-" + ChangeNum(ch_month) + "-" + ChangeNum(ch_day);
		}else{
			alert('��¥�� ������ "2002-01-23" �Ǵ� "200020123" �Դϴ�.');
			return "";
		}
	}else{
		return "";
	}
}

/* Date ������ ��ȭ��Ų��.. (��¥ �˻��� '-' ���̱�)*/
function ChangeDate_add(arg)
{
	ch_date = replaceString("-","",arg);
	if(ch_date!=""){
		if(ch_date.length == 8){
			year = ch_date.substring(0,4);
			month = ch_date.substring(4,6);
			day = ch_date.substring(6,8);
			return year+"-"+month+"-"+day;		
		}else if(ch_date.length == 6){
			year = ch_date.substring(0,4);
			month = ch_date.substring(4,6);
			return year+"-"+month;		
		}else if(ch_date.length == 4){
			year = ch_date.substring(0,4);
			return year+"-";		
		}
	}else{
		return "";
	}
}

/* Date ������ ��ȭ��Ų��.. (��¥ �˻��� '-' ���̱�)*/
function ChangeDate_nb(arg)
{
	ch_date = replaceString("-","",arg);
	if(ch_date!=""){
		if(ch_date.length == 8){
			year = ch_date.substring(0,4);
			month = ch_date.substring(4,6);
			day = ch_date.substring(6,8);
			return year+month+day;		
		}else if(ch_date.length == 6){
			year = ch_date.substring(0,4);
			month = ch_date.substring(4,6);
			return year+month;		
		}else if(ch_date.length == 4){
			year = ch_date.substring(0,4);
			return year;		
		}
	}else{
		return "";
	}
}

/* ������ ���ڸ����� 0�� ���δ�. */
function ChangeNum(arg)
{
	if(arg==1 || arg==2 || arg==3 || arg==4 || arg==5 || arg==6 || arg==7 || arg==8 || arg==9)
	{
		arg='0'+arg;
	}
	return arg;
}

//����üũ(���ϰ� 1�̸� ����)
function leapYear (Year) {
    if (((Year % 4)==0) && ((Year % 100)!=0) || ((Year % 400)==0))
        return (1);
    else
        return (0);
}

/* Ư���⵵,���� ���������� �����´�.*/
function getDaysInMonth(year,month)  {

	var days;
	if (month==01 || month==03 || month==05 || month==07 || month==08 || month==10 || month==12)  days=31;
	else if (month==04 || month==06 || month==09 || month==11) days=30;
	else if (month==02)  {
		if (leapYear (year)==1)  days=29;
		else days=28;
	}
	return (days);
}

/* �����߿� Ư�����ڸ� ���ش�.*/
function replaceString(oldS,newS,fullS) 
{
	for (var i=0; i<fullS.length; i++) 
	{      
		if (fullS.substring(i,i+oldS.length) == oldS) 
		{         
			fullS = fullS.substring(0,i)+newS+fullS.substring(i+oldS.length,fullS.length);   
		}   
	}   
	return fullS;
}

/* parseInt�� �� ���� NaN���� Ȯ�� */
function checkNaN(num)
{
	if(isNaN(num))
		return 0;
	else
		return num;
}

/* ���ް� ����*/
function sup_amt(num)
{
	if(isNaN(num))
		return 0;
	else if(num == 0)
		return 0;
	else
		return Math.round(num/1.1);
}
/*
// �������� �ݿø� 
function ten_th_rnd(num)
{
	if(isNaN(num))
		return 0;
	else if(num == 0)
		return 0;
	else
	{
		var s_num = num.toString();
		//1000�ڸ� ��
		var fth_digit = parseInt(s_num.substr(s_num.length-4, 1), 10);
		//10000�������� �ڸ� ��
		var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-4), 10)) * 10000;
		if(fth_digit >= 5)
			return rnd_ten_thos + 10000;
		else
			return rnd_ten_thos;
	}	
}
*/
	/* �������� �ݿø�  */
	function ten_th_rnd(num){
		if(isNaN(num))
			return 0;
		else if(num == 0)
			return 0;
		else{
			if(num < 0){
				return 0;
			}else{		
				num = Math.round(num);				
				var s_num = num.toString();
				/* 1000�ڸ� ��*/
				var fth_digit = parseInt(s_num.substr(s_num.length-4, 1), 10);
				/* 10000�������� �ڸ� ��*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-4), 10)) * 10000;
				if(fth_digit >= 5)
					return rnd_ten_thos + 10000;
				else
					return rnd_ten_thos;
			}
		}	
	}

/* �������� ���� */
function ten_th_rnd_t(num)
{
	var s_num = num.toString();
	var len=s_num.length();	
	var rnd_ten_thos;
	alert(rnd_ten_thos);
	if(len >= 5){
		rnd_ten_thos = s_num.substr(0, len-4) + '0000';
	}
	alert(rnd_ten_thos);	
	return rnd_ten_thos;
}

/* õ������ ����  */
function hun_th_rnd(num)
{
	if(isNaN(num))
		return 0;
	else if(num == 0)
		return 0;
	else
	{
		var s_num = num.toString();
		/* 100�ڸ� ��*/
		var fth_digit = parseInt(s_num.substr(s_num.length-3, 1), 10);
		/* 1000�������� �ڸ� ��*/
		var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-3), 10)) * 1000;
		return rnd_ten_thos;
	}	
}
/* ������� ����  */
function bak_th_rnd(num)
{
	if(isNaN(num))
		return 0;
	else if(num == 0)
		return 0;
	else
	{
		var s_num = num.toString();
		/* 10�ڸ� ��*/
		var fth_digit = parseInt(s_num.substr(s_num.length-2, 1), 10);
		/* 100�������� �ڸ� ��*/
		var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-2), 10)) * 100;
		return rnd_ten_thos;
	}	
}
/* ������� �ݿø�  */
function bak_th_rnd2(num)
{
	if(isNaN(num))
		return 0;
	else if(num == 0)
		return 0;
	else
	{
		var s_num = num.toString();
		/* 10�ڸ� ��*/
		var fth_digit = parseInt(s_num.substr(s_num.length-2, 1), 10);
		/* 100�������� �ڸ� ��*/
		var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-2), 10)) * 100;
		if(fth_digit >= 3)
			return rnd_ten_thos + 100;
		else
			return rnd_ten_thos;	
	}	
}
/* �ʿ����� ����  */
function th_rnd(num)
{
	if(isNaN(num))
		return 0;
	else if(num == 0)
		return 0;
	else
	{
		var s_num = num.toString();		
		var last = s_num.length;
		if(s_num.indexOf('.') != -1) last = s_num.indexOf('.');		
		/* 10�������� �ڸ� ��*/
		var rnd_ten_thos = s_num.substr(0, last-1)+'0';
		return parseInt(rnd_ten_thos);
	}	
}

	/* õ������ �ݿø�  */
	function th_rnd_esti(num){
		if(isNaN(num))
			return 0;
		else if(num == 0)
			return 0;
		else{
			if(num < 0){
				return 0;
			}else{
				num = Math.round(num);				
				var s_num = num.toString();
				/* 100�ڸ� ��*/
				var fth_digit = parseInt(s_num.substr(s_num.length-3, 1), 10);
				/* 1000�������� �ڸ� ��*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-3), 10)) * 1000;
				if(fth_digit >= 5)
					return rnd_ten_thos + 1000;
				else
					return rnd_ten_thos;
			}
		}	
	}

/* �ʿ����� ����  */
function th_rnd_10(num)
{
	if(isNaN(num))
		return 0;
	else if(num == 0)
		return 0;
	else
	{
		var s_num = num.toString();		
		var last = s_num.length;
		if(s_num.indexOf('.') != -1) last = s_num.indexOf('.');		
		/* 10�������� �ڸ� ��*/
		var rnd_ten_thos = s_num.substr(0, last-1)+'0';
		return parseInt(rnd_ten_thos);
	}	
}

/* �ʿ����� �ݿø�  */
function th_round(num)
{
	if(isNaN(num))
		return 0;
	else if(num == 0)
		return 0;
	else
	{
		num = num*0.1;
		num = Math.round(num);		
		var s_num = num.toString();		
		var rnd_ten_thos = s_num+'0';
		return parseInt(rnd_ten_thos);
	}	
}

/* string to integer */
function toInt(str)
{
	var num = parseInt(str, 10);
	return checkNaN(num);
}

/* string to float */
function toFloat(str)
{
	var num = parseFloat(str, 10);
	return checkNaN(num);
}
function parseFloatCipher(num, cipher){
	var str = num.toString();
	if(checkNaN(str)){
		var tot_len = str.length;
		var dot_post = str.indexOf(".");		
		if(dot_post == -1){
			return num;
		}else{
			var len = str.substring(dot_post+1).length;
			if(len <= cipher){
				return parseFloat(str);
			}else{
				str = str.substring(0, dot_post+1)+str.substring(dot_post+1, dot_post+1+cipher);
				return parseFloat(str);
			}
		}
	}else{
		return 0;
	}	
}
function parseFloatCipher2(str){
	if(checkNaN(str)){
		var dot_post = str.indexOf(".");		
		if(dot_post == -1){
			return str+".0";
		}else{
			return str;
		}
	}else{
		return str;
	}	
}
function parseFloatCipher3(num, cipher){
	var str = num.toString();
	if(checkNaN(str)){
		var dot_post = str.indexOf(".");
		if(dot_post == -1){
			if(cipher ==1)	return str+=".0";			
			if(cipher ==2)	return str+=".00";
		}else{
			var len = str.substring(dot_post).length-1;
			if(len == cipher){
				return parseFloat(str);
			}else if(len < cipher){
				if(cipher-len ==1)	return str+="0";			
				if(cipher_len ==2)	return str+="00";
				return parseFloat(str);				
			}else{
				str = str.substring(0, dot_post+1)+str.substring(dot_post+1, dot_post+1+cipher);
				return str;
			}
		}
	}else{
		return str;
	}	
}

/**
 *	�Ϲݼ��������� number�� ��ȭ������ ���ڿ��� ����
 */
function parseDecimal(num)
{
	var str = num.toString();
	str = toInt(parseDigit(str)).toString();
	var str_size = str.length;
	var new_str = '';
	var pre_rest_cnt = str_size%3;
	var rest_cnt;
	if(pre_rest_cnt == 0)	rest_cnt = 3;
	else					rest_cnt = pre_rest_cnt;
	for(var i = 0 ; i < str_size ; i++ )
	{
		new_str = new_str + str.charAt(i);
		if(((i+1)==rest_cnt) || ((i != 1) && (i != 2) && ((((i+1)%3)==rest_cnt) || (((i+1)%3)==pre_rest_cnt))))
		{
			if(((i+1) != str_size) && (!isNaN(str.charAt(i))))
				new_str = new_str+',';
		}
	}
	return new_str;
}

/**
 *	�Ϲݼ��������� number�� ��ȭ������ ���ڿ��� ����
 */
function parseDecimal_hun_th_rnd(num)
{
	var str = num.toString();
	str = toInt(parseDigit(str)).toString();
	var str_size = str.length;
	var new_str = '';
	var pre_rest_cnt = str_size%3;
	var rest_cnt;
	if(pre_rest_cnt == 0)	rest_cnt = 3;
	else					rest_cnt = pre_rest_cnt;
	for(var i = 0 ; i < str_size ; i++ )
	{
		new_str = new_str + str.charAt(i);
		if(((i+1)==rest_cnt) || ((i != 1) && (i != 2) && ((((i+1)%3)==rest_cnt) || (((i+1)%3)==pre_rest_cnt))))
		{
			if(((i+1) != str_size) && (!isNaN(str.charAt(i))))
				new_str = new_str+',';
		}
	}
	if(new_str.length > 3){
		new_str = new_str.substring(0,new_str.length-3)+'000';
	}
	
	return new_str;
}

/**
 *	�Ϲݼ��������� number�� ��ȭ������ ���ڿ��� ����(�Ҽ��� ����)
 */
function parseDecimal2(num)
{
	var str = num.toString();
	var str2 = '';
	var len = str.indexOf(".");
	if(len != -1){
		str = num.toString().substring(0,len);
		str2 = num.toString().substring(len);
	}
	if(str2 ==0){
		str2 = '';
	} 
	str = toInt(parseDigit(str)).toString();
	var str_size = str.length;
	var new_str = '';
	var pre_rest_cnt = str_size%3;
	var rest_cnt;
	if(pre_rest_cnt == 0)	rest_cnt = 3;
	else					rest_cnt = pre_rest_cnt;
	for(var i = 0 ; i < str_size ; i++ )
	{
		new_str = new_str + str.charAt(i);
		if(((i+1)==rest_cnt) || ((i != 1) && (i != 2) && ((((i+1)%3)==rest_cnt) || (((i+1)%3)==pre_rest_cnt))))
		{
			if(((i+1) != str_size) && (!isNaN(str.charAt(i))))
				new_str = new_str+',';
		}
	}
	return new_str+str2;
}

/**
 *	��ȭ������ ���ڿ��� �Ϲݼ��������� ���ڿ��� ����
 */
function parseDigit(str)
{
	var str_size = str.length;
	var new_str = '';
	for(var i = 0 ; i < str_size ; i++ )
	{
		if(str.charAt(i) != ',')
		//if(isNum(str.charAt(i)))
			new_str = new_str+str.charAt(i);
	}
	return new_str;
}

/**
 *	�������� üũ
 */
function isNum(str)
{
	if(str == '')
		return true;
	else
	{
		if(isNaN(str))
			return false;
		else
			return true;
	}
}

/**
 *	�������� üũ(�Ҽ��� ����)
 */
function isPointNum(str)
{
	if(str == '')
		return true;
	else
	{
		var flag = 0;
		var str_size = str.length;
		for(var i = 0 ; i < str_size ; i++ )
		{
			if(str.charAt(i) != '.')
			{
				if(isNaN(str.charAt(i)))
					flag += 1;
			}
		}
	}
	
	if(flag != 0)	return false;
	else			return true;
}

/**
 *	�������� üũ(+,-��ȣ ����)
 */
function isSignalNum(str)
{
	if(str == '')
		return true;
	else
	{
		var flag = 0;
		var str_size = str.length;
		for(var i = 0 ; i < str_size ; i++ )
		{
			if((str.charAt(i) != '-') && (str.charAt(i) != '+') && (str.charAt(i) != ','))
			{
				if(isNaN(str.charAt(i)))
					flag += 1;
			}
		}
	}
	
	if(flag != 0)	return false;
	else			return true;
}
/**
 *	��ȭ��ȣ ��ȿ�� üũ(���ڿ� '-'���ڸ� ���)
 */
function isTel(str)
{
	if(str == '')
		return true;
	else
	{
		var flag = 0;
		var str_size = str.length;
		for(var i = 0 ; i < str_size ; i++ )
		{
			if(str.charAt(i) != '-')
			{
				if(isNaN(str.charAt(i)))
					flag += 1;
			}
		}
	}
	
	if(flag != 0)	return false;
	else			return true;
}

/**
 *	�ݾ� ��ȿ�� üũ(���ڿ� ','���ڸ� ���)
 */
function isCurrency(str)
{
	if(str == '')
		return true;
	else
	{
		var flag = 0;
		var str_size = str.length;
		for(var i = 0 ; i < str_size ; i++ )
		{
			if(str.charAt(i) != ',')
			{
				if(isNaN(str.charAt(i)))
					flag += 1;
			}
		}
	}
	
	if(flag != 0)	return false;
	else			return true;
}

/**
 *	��¥ ��ȿ�� üũ(���ڿ� '-'���ڸ� ���, ����üũ)
 */
function isDate(str)
{
	if(str == '')
		return true;
	else if(str.length == 10)
	{
		var flag = 0;
		var str_size = str.length;
		for(var i = 0 ; i < str_size ; i++ )
		{
			if(str.charAt(i) != '-')
			{
				if(isNaN(str.charAt(i)))
					flag += 1;
			}
		}
	}
	else
		return false;
	
	if(flag != 0)	return false;
	else			return true;
}

//���̱��ϱ�
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}
//���� üũ
function max_length(f, max_len){
	if (get_length(f) > max_len)
		return false;
	else 
		return true;
}

//���ó�¥(20030101)
function getToday(){
	var year = (new Date()).toString().substring(28);
	var month = (new Date()).getMonth() + 1;
	var day = (new Date()).getDate();
	if(month < 10) month="0"+month;
	if(day < 10) day="0"+day;
	var today = year+month+day;
	return today;
}
//���ó�¥(2003-01-01)
function getTodayBar(){
	var year = (new Date()).toString().substring(28);
	var month = (new Date()).getMonth() + 1;
	var day = (new Date()).getDate();
	if(month < 10) month="0"+month;
	if(day < 10) day="0"+day;
	var today = year+"-"+month+"-"+day;
	return today;
}
//���ϳ�¥(2003.01.01)
function getTomaDot(){
	var year = (new Date()).toString().substring(28);
	var month = (new Date()).getMonth() + 1;
	var day = (new Date()).getDate()+1;
	if(month < 10) month="0"+month;
	if(day < 10) day="0"+day;
	var today = year+"."+month+"."+day;
	return today;
}
//���ϳ�¥(2003-01-01)
function getTomaBar(){
	var year = (new Date()).toString().substring(28);
	var month = (new Date()).getMonth() + 1;
	var day = (new Date()).getDate()+1;
	if(month < 10) month="0"+month;
	if(day < 10) day="0"+day;
	var today = year+"-"+month+"-"+day;
	return today;
}
//���ϳ�¥(2003-01-01)
function getAddDateBar(dt, days){
	var today = new Date(replaceString("-","/",dt));
	var year = today.toString().substring(28);
	var month = today.getMonth() + 1;
	var day = today.getDate();
	var w_date = year+"-"+month+"-"+day;	
	if(month == "12" && day == "31"){
		year = toInt(year)+1;		
		month = "1";
		day = days;
	}else{
		var max_day = getMonthDateCnt(year, month);
//		alert(w_date+" "+max_day+" "+day);
		if(day == max_day){
			month = toInt(month)+1;
			day = days;
		}else{
			day = toInt(day)+days;
		}
	}	
	if(month < 10) month="0"+month;
	if(day < 10) day="0"+day;
	var date = year+"-"+month+"-"+day;
	return date;
}
/* �ֹε�Ϲ�ȣ ������ ��ȭ��Ų��.. (�ֹε�Ϲ�ȣ �˻��� '-' ���̱�)*/
function ChangeSsn(arg)
{
	ch_ssn = replaceString("-","",arg);
	
	if(ch_ssn!=""){
		if(ch_ssn.length == 13){
			var ssn1 = ch_ssn.substring(0,6);
			var ssn2 = ch_ssn.substring(6,13);
			return ssn1+"-"+ssn2;		
		}else{
			alert('�ֹε�Ϲ�ȣ�� ������ "030101-3000000" �Ǵ� "0301013000000" �Դϴ�.');
			return arg;
		}
	}else{
		return arg;
	}
}

/* �����ȣ ������ ��ȭ��Ų��.. (�����ȣ �˻��� '-' ���̱�)*/
function ChangeLic_no(arg)
{
	ch_lic_no = replaceString("-","",arg);
	if(ch_lic_no!=""){
		if(ch_lic_no.length == 12){
			var lic_no1 = ch_lic_no.substring(0,4);
			var lic_no2 = ch_lic_no.substring(4,10);
			var lic_no3 = ch_lic_no.substring(10,12);
			arg = lic_no1+"-"+lic_no2+"-"+lic_no3;
//			return lic_no1+"-"+lic_no2+"-"+lic_no3;					
//			return ch_lic_no;		
		}else{
			alert('�����ȣ�� ������ "0000-000000-00" �Ǵ� "����0000000000" ��\n\n " - " ���� 12�� �Դϴ�.');
//			alert('�����ȣ�� ������ "����00-0000-00" �Ǵ� "����00000000" �Դϴ�.');
//			alert('�����ȣ�� ���Ŀ� ���߾ �Է� ���ּ���');
//			return arg;
		}
//	}else{
//		return arg;
	}
	return arg;
}

/* �����ȣ ������ ��ȭ��Ų��.. (�����ȣ �˻��� '-' ���̱�) ����Խ� ��� �뵵*/
function CheckLic_no(arg)
{
	var chk_result = 'N'
	ch_lic_no = replaceString("-","",arg);
	if(ch_lic_no!=""){
		if(ch_lic_no.length == 12){
			var lic_no1 = ch_lic_no.substring(0,4);
			var lic_no2 = ch_lic_no.substring(4,10);
			var lic_no3 = ch_lic_no.substring(10,12);
			arg = lic_no1+"-"+lic_no2+"-"+lic_no3;
			chk_result = 'Y';
		}else{
			alert('�����ȣ�� ������ "0000-000000-00" �Ǵ� "����0000000000" ��\n\n " - " ���� 12�� �Դϴ�.');
		}
	}
	return chk_result;
}

//����� ���� ��¥ ����
function getInsChangeDt(str){
	if(str == '')
		return str;
	else if(str.length == 10){
		year = toInt(str.substring(0,4))+1;
		ch_date = year+str.substring(4);
		return ch_date;
	}
}

 // ���ڿ� ������ ��� ���۴ϴ�.
function Space_All(str)
{
  var index, len
           
  while(true)
  {
   index = str.indexOf(" ")
   // ������ ������ �����մϴ�.
   if (index == -1) break
   // ���ڿ� ���̸� ���մϴ�.
   len = str.length
   // ������ �߶���ϴ�.
   str = str.substring(0, index) + str.substring((index+1),len)
  }
   
  return str;
}

function checkDate(fieldCalledName,field){
    /* 
    ****************************************************************************************************
    *  �Լ�����: ���������� �Էµ� ��¥�� ���������� �˻��Ѵ�.
    *
    * fieldCalledName : ���ڼ� üũ�� �� �Է��ʵ��� �ѱ۸�Ī. ���� �޽��� ��� �ÿ� ����Ѵ�.
    * field    : html���� name���� ������ �Է��ʵ� ��ü
    *
    * ��뿹  <input type='text' name='test3' onBlur="javascript:checkDate('������',this);" >
    ****************************************************************************************************
    */
   
  
 field=trim(field);    
 if(!checkInputNumber(fieldCalledName,field)) {
  return false;
 }
 var year = field.substring(0, 4);
 var month = field.substring(4, 6);
 var day = field.substring(6,8);
// alert(year+"�� "+month+"�� "+day+"��");
    if (year < 1900 || year >2037){
        alert('��¥�� �߸� �ԷµǾ����ϴ�. �⵵�� 1900�⿡�� 2037����� �Դϴ�.');
        return false;
    }
    if (month <1 || month > 12){
        alert('��¥�� �߸� �ԷµǾ����ϴ�. ���� 1������ 12������ �Դϴ�.'); 
        return false;
    }
    if (day < 1 ||  !isValidDay(year, month,day)){
        alert('��¥�� �߸� �ԷµǾ����ϴ�. '+ year+ "�� " +month+'������ '+ day+'���� �����ϴ�.');
	    field=field.substring(0,field.length-2);        
        return false;
    } 
 return true;
}

function checkInputNumber(fieldCalledName,field){
    /* 
    ****************************************************************************************************
    *  �Լ�����: �Է¶��� ���ڸ��� �ԷµǴ��� üũ�Ѵ�.
    *
    * fieldCalledName : ���ڼ� üũ�� �� �Է��ʵ��� �ѱ۸�Ī. ���� �޽��� ��� �ÿ� ����Ѵ�.
    * field    : html���� name���� ������ �Է��ʵ� ��ü
    *
    * ��뿹
    ****************************************************************************************************
    */
 if(field != ""){
 	field = replaceString("-","",field);
  if(!isContainsOnly(field, "0123456789")) {
    alert(fieldCalledName + "��(��) ���ڿ��� ���ڿ��� �Է��� �� �����ϴ�.");
  	field=field.substring(0,field.length-1); 
  	return false;
  }else{
  	//����üũ �� ���ϼ��� üũ
  	if(fieldCalledName == "CMS ���¹�ȣ"){
  		if(field.length < 10){
  			alert(fieldCalledName + "��(��) 9�ڸ��� �̻��Դϴ�.");
  			return false;
  		}else{
  			var c_field = field.substring(0,10);
  			if(c_field == "0000000000" || c_field == "1111111111" || c_field == "2222222222" || c_field == "3333333333" || c_field == "4444444444" || c_field == "5555555555" || c_field == "6666666666" || c_field == "7777777777" || c_field == "8888888888" || c_field == "9999999999" || c_field == "1234567890" || c_field == "0123456789"){
  				alert(fieldCalledName + " �߸��� ����ȣ�Դϴ�. Ȯ���Ͻʽÿ�.");
  				return false;
  			}	
  		}
  	}else if(fieldCalledName == "ī���ȣ"){
  		if(field.length < 15){
  			alert(fieldCalledName + "��(��) 15�ڸ��� �Դϴ�.");
  			return false;
  		}
  	}
  }
 }
    return true;
}	

function isContainsOnly(str,chars) {
    /*
    *********************************************************************************************************
    *   �Լ�����  : �ش繮�ڿ��� ������ ���ڵ鸸�� �����ϰ� �ִ��� �˻��Ѵ�.
    * str    : �˻��� ���ڿ�
    * chars   : ������ ���ڵ��� ����
    ***********************************************************************************************************
    */     
    for (var inx = 0; inx < str.length; inx++) {
       if (chars.indexOf(str.charAt(inx)) == -1)
       return false; 
    }
    return true;
}

function isValidDay(year, month, day) {
    /*
    *********************************************************************************************************
    *   �Լ�����  : �����ϴ� ��,��,���� �޷»����� �����ϴ� ��¥���� �˻��Ѵ�.
    * year    : ��
    * month   : ��
    * day    : ��
    ***********************************************************************************************************
    */     
    var m = parseInt(month,10) - 1;
    var d = parseInt(day,10);
    var end = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        end[1] = 29;
    }
    return (d >= 1 && d <= end[m]);
}


function lTrim(str){
    /*
    *********************************************************************************************************
    *   �Լ�����  : ���ڿ����� ������ ������ �����Ѵ�.
    * str    : ���ڿ�
    ***********************************************************************************************************
    */
  var i;
  i = 0;
  while (str.substring(i,i+1) == ' ' || str.substring(i,i+1) == '��')  i = i + 1;
  return str.substring(i);
}

function rTrim(str){
    /*
    *********************************************************************************************************
    *   �Լ�����  : ���ڿ����� �������� ������ �����Ѵ�.
    * str    : ���ڿ�
    ***********************************************************************************************************
    */

  var i = str.length - 1;
  while (i >= 0 && (str.substring(i,i+1) == ' ' || str.substring(i,i+1) == '��')) i = i - 1;
  return str.substring(0,i+1);
}

function trim(str){
    /*
    *********************************************************************************************************
    *   �Լ�����  : ���ڿ����� ������ ������ �����Ѵ�.
    * str    : ���ڿ�
    ***********************************************************************************************************
    */
    if( str == "" || str.length ==0 ) 
    {
      return str; 
    } 
    else
    {
      return(lTrim(rTrim(str)));
    }   
}




function ChangeDate4(dt_v, arg)
{
	var ch_date = replaceString("-","",arg);

	if(ch_date!="")
	{
		if(ch_date.length!=8)
		{
			alert('��¥�� ������ "2002-01-23" �Ǵ� "20020123" �Դϴ�.');
			dt_v.focus();
			return "";
		}else{
			ch_year = parseInt(ch_date.substring(0,4),10);
			ch_month = parseInt(ch_date.substring(4,6),10);
			ch_day = parseInt(ch_date.substring(6,8),10);
			if(isNaN(ch_date))
			{
				alert("���ڿ� '-' ���� �Է°����մϴ�.");
				dt_v.focus();
				return "";
			}
			if(!(ch_month>0 && ch_month<13))
			{
				alert("���� 01 - 12 ������ �Է� �����մϴ�.");
				dt_v.focus();
				return "";
			}
			ck_day = getDaysInMonth(ch_year,ChangeNum(ch_month))
			if(ck_day<ch_day)
			{
				alert("���� 01 - " + ck_day + " ������ �Է� �����մϴ�.");
				dt_v.focus();
				return "";
			}		
			return ch_year + "-" + ChangeNum(ch_month) + "-" + ChangeNum(ch_day);
		}
	}else{
		return "";
	}
}

function ChangeDate4_chk(dt_v, arg)
{
	var ch_date = replaceString("-","",arg);

	if(ch_date!="")
	{
		if(ch_date.length!=8)
		{
			//alert('��¥�� ������ "2002-01-23" �Ǵ� "20020123" �Դϴ�.');
			//dt_v.focus();
			return "";
		}else{
			ch_year = parseInt(ch_date.substring(0,4),10);
			ch_month = parseInt(ch_date.substring(4,6),10);
			ch_day = parseInt(ch_date.substring(6,8),10);
			if(isNaN(ch_date))
			{
				//alert("���ڿ� '-' ���� �Է°����մϴ�.");
				//dt_v.focus();
				return "";
			}
			if(!(ch_month>0 && ch_month<13))
			{
				//alert("���� 01 - 12 ������ �Է� �����մϴ�.");
				//dt_v.focus();
				return "";
			}
			ck_day = getDaysInMonth(ch_year,ChangeNum(ch_month))
			if(ck_day<ch_day)
			{
				//alert("���� 01 - " + ck_day + " ������ �Է� �����մϴ�.");
				//dt_v.focus();
				return "";
			}		
			return ch_year + "-" + ChangeNum(ch_month) + "-" + ChangeNum(ch_day);
		}
	}else{
		return "";
	}
}


function addMonth(b_date, mons)
{

	m  = 30*24*60*60*1000;		//��
	l  = 24*60*60*1000;  		// 1��
	
	var d1 = replaceString('-','',b_date);
	
	var t1 = new Date(d1.substr(0,4), d1.substr(4,2), d1.substr(6,2));
	
	
	t1.setTime(t1.getTime()+(m*toInt(mons))+l );
	
	
	var t_y = t1.getFullYear();
	var t_m = t1.getMonth();
	var t_d = t1.getDate();
	
	
	if(t_m < 10)		t_m = '0'+t_m;
	if(t_d < 1)		t_d = '0'+t_d;
	
	return t_y+'-'+t_m+'-'+t_d;
}

function addDay(b_date, days)
{

	m  = 30*24*60*60*1000;		//��
	l  = 24*60*60*1000;  		// 1��
	
	var d1 = replaceString('-','',b_date);
	
	var t1 = new Date(d1.substr(0,4), d1.substr(4,2), d1.substr(6,2));
	
	t1.setTime(t1.getTime()+(l*toInt(days)) );
	
	var t_y = t1.getFullYear();
	var t_m = t1.getMonth();
	var t_d = t1.getDate();
	
	if(t_m < 10)		t_m = '0'+t_m;
	if(t_d < 1)			t_d = '0'+t_d;
	
	return t_y+'-'+t_m+'-'+t_d;
}



function isView(type,seq){
	var isImage = type.indexOf("image/") != -1 ? true : false;
	var isPDF = type.indexOf("pdf") != -1 ? true : false;
	var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
	if( isImage || isPDF ){
		if(type.indexOf("image/") != -1 ) {
			url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview.jsp';
		}				
		url = url + "?SEQ=" + seq;
		//window.open(url, "", "scrollbars=yes, status=yes, resizable=1");
		location.href = url + "?SEQ=" + seq;
	}else{
		alert('���⸦ �Ҽ����� �����Դϴ�.');
	} 			
}

function isView2(type,seq){
	var isImage = type.indexOf("image/") != -1 ? true : false;
	var isPDF = type.indexOf("pdf") != -1 ? true : false;
	var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
	if( isImage || isPDF ){
		if(type.indexOf("image/") != -1 ) {
			url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview.jsp';
		}				
		url = url + "?SEQ=" + seq;
		window.open(url, "view_file", "scrollbars=yes, status=yes, resizable=1");
		//location.href = url + "?SEQ=" + seq;
	}else{
		alert('���⸦ �Ҽ����� �����Դϴ�.');
	} 			
}

		function openPop(type,seq){
			
			var isImage = type.indexOf("image/") != -1 ? true : false;
			var isPDF = type.indexOf("pdf") != -1 ? true : false;
			var isTIF  = type.indexOf("/tif") != -1 ? true : false;
			var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
		
					
			if( isImage || isPDF ){
				if(type.indexOf("image/") != -1 ) {
					url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview.jsp';
				}
				
				if(isTIF) {
					url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
				}
								
				url = url + "?SEQ=" + seq;
				var popName = "view_file";
				var aTagObj = document.getElementById("link_view_a");
				
				if( aTagObj == null ){
					var aTag = document.createElement("a");
					aTag.setAttribute("href", url);
					aTag.setAttribute("target",popName);
					aTag.setAttribute("id","link_view_a");
					target = document.getElementsByTagName("body");
					target[0].appendChild(aTag);
					aTagObj = document.getElementById("link_view_a");
				}else{
					aTagObj.setAttribute("href", url);
				}
				
				if(isTIF) {
					   //alert("tif");
						var pop = window.open('', popName, "left=300, top=250, width=500, height=500, scrollbars=no");
				} else {
					
			   	var pop = window.open('', popName, "left=300, top=250, width=1000, height=1000, scrollbars=yes");
			   }
			
				aTagObj.click();
				
				
			}else{
				alert('���⸦ �Ҽ����� �����Դϴ�.');
			} 	
		}
		
		function openPopP(type,seq){
			var isImage = type.indexOf("image/") != -1 ? true : false;
			var isPDF = type.indexOf("pdf") != -1 ? true : false;
			var isTIF  = type.indexOf("/tif") != -1 ? true : false;
						
			var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
			if( isImage || isPDF ){
				if(type.indexOf("image/") != -1 ) {				
					url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview_print.jsp';
				}
				
				if(isTIF) {
					url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
				}
								
				url = url + "?SEQ=" + seq;
				var popName = "view_file";
				var aTagObj = document.getElementById("link_view_a");
				
				if( aTagObj == null ){
					
					var aTag = document.createElement("a");
					aTag.setAttribute("href", url);
					aTag.setAttribute("target",popName);
					aTag.setAttribute("id","link_view_a");
					target = document.getElementsByTagName("body");
					target[0].appendChild(aTag);
					aTagObj = document.getElementById("link_view_a");
				
				}else{
				
					aTagObj.setAttribute("href", url);
				}
				
			    if(isTIF) {
				//	   alert("tif");
						var pop = window.open('', popName, "left=300, top=250, width=500, height=500, scrollbars=no");
				} else {
					
			   	var pop = window.open('', popName, "left=300, top=250, width=1000, height=1000, scrollbars=yes");
			   }
			   
				
				aTagObj.click();
				
				
			}else{
				alert('���⸦ �Ҽ����� �����Դϴ�.');
			} 	
		}		
		
		function openPopF(type,seq){
			
			var isImage = type.indexOf("image/") != -1 ? true : false;
			var isPDF = type.indexOf("pdf") != -1 ? true : false;
			var isTIF  = type.indexOf("/tif") != -1 ? true : false;
			var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
		
					
			if( isImage || isPDF ){
				if(type.indexOf("image/") != -1 ) {
					url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview_full.jsp';
				}
				
				if(isTIF) {
					url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
				}
								
				url = url + "?SEQ=" + seq;
				var popName = "view_file";
				var aTagObj = document.getElementById("link_view_a");
				
				if( aTagObj == null ){
					var aTag = document.createElement("a");
					aTag.setAttribute("href", url);
					aTag.setAttribute("target",popName);
					aTag.setAttribute("id","link_view_a");
					target = document.getElementsByTagName("body");
					target[0].appendChild(aTag);
					aTagObj = document.getElementById("link_view_a");
				}else{
					aTagObj.setAttribute("href", url);
				}
				
				if(isTIF) {
					   //alert("tif");
						var pop = window.open('', popName, "left=300, top=250, width=500, height=500, scrollbars=no");
				} else {
					
			   	var pop = window.open('', popName, "left=300, top=250, width=1000, height=1000, scrollbars=yes");
			   }
			
				aTagObj.click();
				
				
			}else{
				alert('���⸦ �Ҽ����� �����Դϴ�.');
			} 	
		}
		
		//Ư������ ����
		//��� �� : <input type='text' value='' OnBlur='checkSpecial();'>
		function checkSpecial(){
			var objEv = event.srcElement;
		 	// var num ="{}[]<>?_|`!@#$%^&*\"'\\/";    //�Է��� ���� Ư������ ����.
		 	var num ="<>\"\'";    // �Է� ���� Ư�� ����(<, >, ', ") ����. 2020.04.28.
			event.returnValue = true;
			var check = false;
			for (var i=0;i<objEv.value.length;i++){
				if(-1 != num.indexOf(objEv.value.charAt(i))){
					event.returnValue = false;
					check = true;
				}
			}  
			if (!event.returnValue){
			 alert("�Ϻ� Ư������(<, >, \', \")�� �Է��Ͻ� �� �����ϴ�.\n\nƯ�����ھ��� �ٽ� �Է����ּ���.");
			 objEv.value="";
			}
		}

		//���ڸ� �Է�
		//��� �� :(�������ſ� ���� ���) <input type='text' onkeyup='removeChar(event);' onkeydown='return onlyNumber(event)'>
		function onlyNumber(event){	
			event = event || window.event;
			var keyID = (event.which) ? event.which : event.keyCode;
			if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 9) 
				return;
			else
				return false;
		}

		//���� ����
		//��� �� :(���ڸ� �Է°� ���� ���) <input type='text' onkeyup='removeChar(event);' onkeydown='return onlyNumber(event)'>
		function removeChar(event) {	
			event = event || window.event;
			var keyID = (event.which) ? event.which : event.keyCode;
			if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
				return;
			else
				event.target.value = event.target.value.replace(/[^0-9]/g, "");
		}