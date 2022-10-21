

/* 십원이하 버힘  */
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
		/* 10단위에서 자른 수*/
		var rnd_ten_thos = s_num.substr(0, last-1)+'0';
		return parseInt(rnd_ten_thos);
	}	
}
/* 십원이하 반올림  */
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
	/* 백이하 반올림  */
	function hun_rnd(num){
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
				/* 1000자리 수*/
				var fth_digit = parseInt(s_num.substr(s_num.length-2, 1), 10);
				/* 10000단위에서 자른 수*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-2), 10)) * 100;
				if(fth_digit >= 5)
					return rnd_ten_thos + 100;
				else
					return rnd_ten_thos;
			}
		}	
	}
	
	/* 천원이하 절사  */
	function th_rndd(num){
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
				/* 1000단위에서 자른 수*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-3), 10)) * 1000;
				return rnd_ten_thos;
			}
		}	
	}

	/* 천원이하 반올림  */
	function th_rnd(num){
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
				/* 100자리 수*/
				var fth_digit = parseInt(s_num.substr(s_num.length-3, 1), 10);
				/* 1000단위에서 자른 수*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-3), 10)) * 1000;
				if(fth_digit >= 5)
					return rnd_ten_thos + 1000;
				else
					return rnd_ten_thos;
			}
		}	
	}
	
	/* 만원이하 반올림  */
	function ten_th_rnd(num){
//alert(num);	
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
				/* 1000자리 수*/
				var fth_digit = parseInt(s_num.substr(s_num.length-4, 1), 10);
				/* 10000단위에서 자른 수*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-4), 10)) * 10000;
				if(fth_digit >= 5)
					return rnd_ten_thos + 10000;
				else
					return rnd_ten_thos;
			}
		}	
	}

	/* 십만원이하 올림  */
	function hun_th_rndup(num){
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
				/* 1000자리 수*/
				var fth_digit = parseInt(s_num.substr(s_num.length-5, 1), 10);
				/* 10000단위에서 자른 수*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-5), 10)) * 100000;
				if(fth_digit > 0)
					return rnd_ten_thos + 100000;
				else
					return rnd_ten_thos;
			}
		}	
	}		
	/* 십만원이하 절사 */
	function hun_th_rndd(num){
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
				/* 100000단위에서 자른 수*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-5), 10)) * 100000;
				return rnd_ten_thos;
			}
		}				
	}
	
	//휴차/대차기간 일자계산
	function set_use_dt(st, et){
		var st = new Date(replaceString("-","/",st));//시작일
		var et = new Date(replaceString("-","/",et));//종료일
		var days = (et - st) / 1000 / 60 / 60 / 24; //1일=24시간*60분*60초*1000milliseconds
		var daysRound = Math.floor(days)+1; //+1:시작일 포함
		return daysRound;
	}	
			
	/* 문자중에 특정문자를 없앤다.*/
	function replaceString(oldS,newS,fullS){
		for(var i=0; i<fullS.length; i++){      
			if (fullS.substring(i,i+oldS.length) == oldS){         
				fullS = fullS.substring(0,i)+newS+fullS.substring(i+oldS.length,fullS.length);   
			}   
		}   
		return fullS;
	}	

	//실수자리수 제한
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
					if(cipher-len ==2)	return str+="00";
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
	/* parseInt한 후 값이 NaN인지 확인 */
	function checkNaN(num){
		if(isNaN(num))
			return 0;
		else
			return num;
	}	
	
/**
 *	일반숫자형식의 number를 통화형식의 문자열로 리턴
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
/* string to integer */
function toInt(str)
{
	var num = parseInt(str, 10);
	return checkNaN(num);
}	
/**
 *	통화형식의 문자열을 일반숫자형식의 문자열로 리턴
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
	//확인
	function up_esti(){
		var fm = document.form1;
		fm.cmd.value = "u";
		fm.target = "i_no";
		fm.submit();
	}	
	
	//취소
	function del_esti(){
		var fm = document.form1;
		fm.cmd.value = "d";
		fm.target = "i_no";
		fm.submit();
	}		
	
/* 공급가 계산식*/
function sup_amt(num)
{
	if(isNaN(num))
		return 0;
	else if(num == 0)
		return 0;
	else
		return Math.round(num/1.1);
}	