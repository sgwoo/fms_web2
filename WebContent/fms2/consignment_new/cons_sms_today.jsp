<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.consignment.*, acar.car_sche.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String attend_ment 	= request.getParameter("attend_ment")==null?"":request.getParameter("attend_ment");
	
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	
	String standby_dt1 = AddUtil.getDate(4);
	String standby_dt2 = af_db.getValidDt(rs_db.addDay(standby_dt1, 1));
	
	//오늘날짜 데이타 조회
	String standby_st1 = cs_db.getConsStandbySt(user_id, standby_dt1);
	String standby_st2 = "1";
	
	if(standby_st1.equals("")) standby_st1 = "1";
	
	
	
	//디폴트 입력하기-------------------------------------
	
	boolean flag = true;
	
	String chk1 = cs_db.getConsStandbySt(user_id, standby_dt1);
	String chk2 = cs_db.getConsStandbySt(user_id, standby_dt2);
	
	//오늘
	if(chk1.equals(""))				flag = cs_db.insertConsStandby(user_id, standby_dt1, "4");
	//내일
	if(chk2.equals(""))				flag = cs_db.insertConsStandby(user_id, standby_dt2, "4");
	
	
	CarScheBean cs_bean1 = csd.getCarScheVacBean(user_id,standby_dt1);
	CarScheBean cs_bean2 = csd.getCarScheVacBean(user_id,standby_dt2);
	
	if(!cs_bean1.getUser_id().equals("")) standby_st1 = "4";
	if(!cs_bean2.getUser_id().equals("")) standby_st2 = "4";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;
		
		if(fm.standby_st1[0].checked == false && fm.standby_st1[1].checked == false && fm.standby_st1[2].checked == false && fm.standby_st1[3].checked == false  ){	 alert("오늘 지원 가능한 구간을 선택하십시오."); 	return;	}
		if(fm.standby_st2[0].checked == false && fm.standby_st2[1].checked == false && fm.standby_st2[2].checked == false && fm.standby_st2[3].checked == false  ){	 alert("내일 지원 가능한 구간을 선택하십시오."); 	return;	}
		
		if(confirm('등록하시겠습니까?')){		
			fm.action='cons_sms_today_a.jsp';
			fm.target='i_no';
			fm.submit();
		}		
	}
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> <span class=style5>자체탁송 지원 스케줄 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 귀하의 <%=attend_ment%></td>
    </tr>	
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 자체탁송 발생시 지원대기자에게 SMS 문자를 발송합니다.</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='25%' class='title'><%=AddUtil.ChangeDate2(standby_dt1)%></td>
                    <td>&nbsp;
        			  <input type='radio' name="standby_st1" value='1' <%if(standby_st1.equals("1"))%>checked<%%>>
        				FULL
        			  <input type='radio' name="standby_st1" value='2' <%if(standby_st1.equals("2"))%>checked<%%>>
        				오전
        			  <input type='radio' name="standby_st1" value='3' <%if(standby_st1.equals("3"))%>checked<%%>>
        				오후
        			  <input type='radio' name="standby_st1" value='4' <%if(standby_st1.equals("4"))%>checked<%%>>
        				없음
        			</td>
    		    </tr>
    		    <tr>
                    <td width='25%' class='title'><%=AddUtil.ChangeDate2(standby_dt2)%></td>
                    <td>&nbsp;
        			  <input type='radio' name="standby_st2" value='1' <%if(standby_st2.equals("1"))%>checked<%%>>
        				FULL
        			  <input type='radio' name="standby_st2" value='2' <%if(standby_st2.equals("2"))%>checked<%%>>
        				오전
        			  <input type='radio' name="standby_st2" value='3' <%if(standby_st2.equals("3"))%>checked<%%>>
        				오후
        			  <input type='radio' name="standby_st2" value='4' <%if(standby_st2.equals("4"))%>checked<%%>>
        				없음
        			</td>
                </tr>		  
            </table>
	    </td>
    </tr>
    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	<tr>
	    <td align="right">
		    <a href="javascript:save();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absbottom" border="0"></a>
        </td>
	</tr>		
    <%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;	
//-->
</script>
</body>
</html>
