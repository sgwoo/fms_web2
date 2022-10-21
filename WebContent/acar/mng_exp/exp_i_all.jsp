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
		if(!isDate(fm.exp_est_dt.value) || fm.exp_est_dt.value == ''){	alert('지출예정일을 확인하십시오');	fm.exp_est_dt.focus(); return;	}	
		if(fm.car_no[0].value == ''){	alert('차량번호를 입력하십시오');	fm.car_no[0].focus();  return;	}		
		if(fm.exp_st.options[fm.exp_st.selectedIndex].value == '3'){
			if(fm.exp_start_dt.value == '' || fm.exp_end_dt.value == '')
													{	alert('과세기간을 입력하십시오');	return;	}
		}		
		
		if(confirm('등록하시겠습니까?'))
		{
			fm.target='i_no';
//			fm.target='REG_EXP_ALL';
			fm.action='exp_i_all_a.jsp';						
			fm.submit();			
		}
	}
	
	function search_client()
	{
		window.open("/acar/mng_exp/car_s.jsp", "EXP_CAR", "left=100, top=100, width=520, height=450");
	}
	
	function set_car_id(idx, car_no)
	{
		var fm = document.form1;
		if(fm.exp_est_dt.value == ''){ alert("지출예정일을 입력하십시오."); fm.exp_est_dt.focus(); return;}
		if(fm.exp_st.value == ''){ alert("지출구분을 선택하십시오."); fm.exp_st.focus(); return;}
		if(car_no != ''){
			fm.h_idx.value = idx;
			fm.h_car_no.value = car_no;
			fm.target='i_no';
			fm.action='exp_nodisplay.jsp';			
			fm.submit();
		}
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

<form action='/acar/mng_exp/exp_i_all_a.jsp' name='form1' method='post'>
<input type='hidden' name='h_idx' value=''>
<input type='hidden' name='h_car_no' value=''>
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
                    <td width=18% class='title'>지출구분</td>
                    <td width=32%> &nbsp; <select name='exp_st' onChange='javascript:exp_display()'>
                        <option value=''>선택</option>
                        <option value='1'>검사비</option>
                        <option value='2'>환경개선부담금</option>
                        <option value='3' selected>자동차세</option>
                      </select> </td>
                    <td width=18% class='title'>지출예정일</td>
                    <td width=32%>&nbsp; <input type='text' name='exp_est_dt' value='' class='text' size='12' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                </tr>
                <tr id=tr_dt style="display:''"> 
					<td class='title'>납부지역 </td>
                    <td colspan=''> &nbsp; <select name='car_ext'>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        <%}%>
                      </select></td>
                    <td class='title'>과세기간</td>
                    <td colspan=""> &nbsp; <select name='dt_st' onChange='javascript:set_exp_dt()'>
                        <option value=''>선택</option>
                        <option value='1'>반기납</option>
                        <option value='2'>연납</option>
                        <option value='3'>수시납</option>
                      </select> <input type='text' name='exp_start_dt' class='text' size='12' maxlength='12' onBlur='javascript:this.value = ChangeDate(this.value);'>
                      ~ 
                      <input type='text' name='exp_end_dt' class='text' size='12' maxlength='12' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                      &nbsp; </td>
                </tr>
                <%for(int i=0;i<10;i++){%>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp; <input type='text' name='car_no' class='text' size='15' onBlur='javascript:set_car_id(<%=i%>, this.value);' style='IME-MODE: active'> 
                      <input type='hidden' name='car_mng_id' value=''> </td>
                    <td class='title' width="100">금액</td>
                    <td>&nbsp; <input type='text' name='exp_amt' class='num' size='12' maxlength='12' onBlur='javascript:this.value = parseDecimal(this.value);'>
                      원</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
	var year = '<%=AddUtil.getDate(1)%>';
	var mon = <%=AddUtil.getDate(2)%>;		
	if(mon <=  6){
		fm.exp_est_dt.value 	= year+'-06-30';
	}else{
		fm.exp_est_dt.value 	= year+'-12-31';			
	}	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>