<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
  CommonDataBase c_db = CommonDataBase.getInstance();

  //차량등록지역
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table_t.css'>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1;
		if((fm.car_mng_id.value == '') || (fm.car_no.value == ''))
													{	alert('차량을 선택하십시오');	return;	}
		else if( !isCurrency(fm.exp_amt.value) || (parseDigit(fm.exp_amt.value).value > 9))
													{	alert('금액을 확인하십시오');	return;	}
		else if(!isDate(fm.exp_est_dt.value))		{	alert('지출예정일을 확인하십시오');	return;	}
		
		if(fm.exp_st.options[fm.exp_st.selectedIndex].value == '3'){
			if(fm.exp_start_dt.value == '' || fm.exp_end_dt.value == '')
													{	alert('과세기간을 입력하십시오');	return;	}
		}

		if(confirm('등록하시겠습니까?'))
		{
			fm.target='i_no';
			fm.submit();
		}
	}
	
	function search_client()
	{
		window.open("/acar/mng_exp/car_s.jsp", "EXP_CAR", "left=100, top=100, width=600, height=450");
	}
	
	//디스플레이 타입
	function exp_display(){
		var fm = document.form1;
		if(fm.exp_st.options[fm.exp_st.selectedIndex].value == '3'){//자동차세
			tr_dt.style.display	= '';
		}else{
			tr_dt.style.display	= 'none';
		}
	}
	//과세기간 셋팅
	function set_exp_dt(){
		var fm = document.form1;
		var year = '<%=AddUtil.getDate(1)%>';
		var mon = <%=AddUtil.getDate(2)%>;		
		if(fm.dt_st.options[fm.dt_st.selectedIndex].value == '1'){//반기납
			if(mon <=  6){
				fm.exp_start_dt.value 	= year+'-01-01';
				fm.exp_end_dt.value 	= year+'-06-30';
			}else{
				fm.exp_start_dt.value 	= year+'-07-01';
				fm.exp_end_dt.value 	= year+'-12-31';			
			}
		}else if(fm.dt_st.options[fm.dt_st.selectedIndex].value == '2'){//연납
			fm.exp_start_dt.value 	= year+'-01-01';
			fm.exp_end_dt.value 	= year+'-12-31';			
		}else{
			fm.exp_start_dt.value 	= '';
			fm.exp_end_dt.value 	= '';
		}	
	}	
	
//-->
</script>
</head>
<body>

<form action='/acar/mng_exp/exp_i_a.jsp' name='form1' method='post'>
<input type='hidden' name='car_mng_id' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 영업비용관리 > 기타등록관련비용 > <span class=style1><span class=style5>지출등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td align='right'><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a></td>
	</tr>  
	<tr> 
        <td class=line2></td>
    </tr>   
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class='title'> 지출구분 </td>
                    <td colspan=''> &nbsp; <select name='exp_st' onChange='javascript:exp_display()'>
                        <option value='1'>검사비</option>
                        <option value='2'>환경개선부담금</option>
                        <option value='3'>자동차세</option>
                      </select></td>
					<td class='title'>납부지역 </td>
                    <td colspan=''> &nbsp; <select name='car_ext'>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        <%}%>
                      </select></td>
                </tr>
                <tr> 
                    <td class='title' width=18%><a href='javascript:search_client()'>차량번호</a> </td>
                    <td width=32%>&nbsp; <input type='text' name='car_no' class='white' size='15' readonly></td>
                    <td width=18% class='title'>차종</td>
                    <td width=32%>&nbsp; <input type='text' name='car_nm' class='white' size='15' readonly></td>
                </tr>
                <tr> 
                    <td class='title'> 상호 </td>
                    <td>&nbsp; <input type='text' name='firm_nm' class='white' size='15' readonly></td>
                    <td class='title'> 계약자 </td>
                    <td>&nbsp; <input type='text' name='client_nm' class='white' size='15' readonly></td>
                </tr>
                <tr> 
                    <td class='title'> 기타사항 </td>
                    <td colspan='3'>&nbsp; <textarea name='exp_etc' cols='66' maxlength='255'></textarea></td>
                </tr>
                <tr> 
                    <td class='title'> 금액 </td>
                    <td>&nbsp; <input type='text' name='exp_amt' class='num' size='12' maxlength='12' onBlur='javascript:this.value = parseDecimal(this.value);'>
                      원</td>
                    <td class='title'> 지출예정일 </td>
                    <td>&nbsp; <input type='text' name='exp_est_dt' class='text' size='12' maxlength='12' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr id=tr_dt style='display:none'> 
                    <td class='title'> 과세기간</td>
                    <td colspan="3">&nbsp; 
                      <select name='dt_st' onChange='javascript:set_exp_dt()'>
                        <option value=''>선택</option>
                        <option value='1'>반기납</option>
                        <option value='2'>연납</option>
                        <option value='3'>수시납</option>
                      </select> 
                      <input type='text' name='exp_start_dt' class='text' size='12' maxlength='12' onBlur='javascript:this.value = ChangeDate(this.value);'>
                      ~ 
                      <input type='text' name='exp_end_dt' class='text' size='12' maxlength='12' onBlur='javascript:this.value = ChangeDate(this.value);'>
        	        </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>