

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
	/* ������ �ݿø�  */
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
				/* 1000�ڸ� ��*/
				var fth_digit = parseInt(s_num.substr(s_num.length-2, 1), 10);
				/* 10000�������� �ڸ� ��*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-2), 10)) * 100;
				if(fth_digit >= 5)
					return rnd_ten_thos + 100;
				else
					return rnd_ten_thos;
			}
		}	
	}
	
	/* õ������ ����  */
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
				/* 1000�������� �ڸ� ��*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-3), 10)) * 1000;
				return rnd_ten_thos;
			}
		}	
	}

	/* õ������ �ݿø�  */
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
	
	/* �������� �ݿø�  */
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

	/* �ʸ������� �ø�  */
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
				/* 1000�ڸ� ��*/
				var fth_digit = parseInt(s_num.substr(s_num.length-5, 1), 10);
				/* 10000�������� �ڸ� ��*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-5), 10)) * 100000;
				if(fth_digit > 0)
					return rnd_ten_thos + 100000;
				else
					return rnd_ten_thos;
			}
		}	
	}		
	/* �ʸ������� ���� */
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
				/* 100000�������� �ڸ� ��*/
				var rnd_ten_thos = (parseInt(s_num.substr(0, s_num.length-5), 10)) * 100000;
				return rnd_ten_thos;
			}
		}				
	}
	
	//����/�����Ⱓ ���ڰ��
	function set_use_dt(st, et){
		var st = new Date(replaceString("-","/",st));//������
		var et = new Date(replaceString("-","/",et));//������
		var days = (et - st) / 1000 / 60 / 60 / 24; //1��=24�ð�*60��*60��*1000milliseconds
		var daysRound = Math.floor(days)+1; //+1:������ ����
		return daysRound;
	}	
			
	/* �����߿� Ư�����ڸ� ���ش�.*/
	function replaceString(oldS,newS,fullS){
		for(var i=0; i<fullS.length; i++){      
			if (fullS.substring(i,i+oldS.length) == oldS){         
				fullS = fullS.substring(0,i)+newS+fullS.substring(i+oldS.length,fullS.length);   
			}   
		}   
		return fullS;
	}	

	//�Ǽ��ڸ��� ����
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
	/* parseInt�� �� ���� NaN���� Ȯ�� */
	function checkNaN(num){
		if(isNaN(num))
			return 0;
		else
			return num;
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
/* string to integer */
function toInt(str)
{
	var num = parseInt(str, 10);
	return checkNaN(num);
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
	//Ȯ��
	function up_esti(){
		var fm = document.form1;
		fm.cmd.value = "u";
		fm.target = "i_no";
		fm.submit();
	}	
	
	//���
	function del_esti(){
		var fm = document.form1;
		fm.cmd.value = "d";
		fm.target = "i_no";
		fm.submit();
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