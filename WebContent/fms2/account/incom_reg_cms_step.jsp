<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.bill_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
		
	function print_cms(){
	
		var fm = document.form1;	
		
		if(fm.aoutdate.value == ""){ alert("출금의뢰일자를 확인하십시오."); return; }				
		
		var adate = fm.aoutdate.value;
	
		window.open("/fms2/account/incom_reg_cms_step_print.jsp?adate="+adate+"&incom_dt="+fm.incom_dt.value , "PAY_CMS_PRINT", "left=150, top=150, width=900, height=650, scrollbars=yes, STATUS=YES, resizable=yes");	
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String incom_dt 	= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int  incom_seq 		= request.getParameter("incom_seq")	==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	int  incom_amt 		= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("incom_amt"));
	String v_gubun 	= request.getParameter("v_gubun")==null?"N":request.getParameter("v_gubun");
	
	
	//해당부분은 수정해야 함//
	
//	incom_dt = "20130605";
//	incom_seq = 1;
//	incom_amt = 17655622;
//	v_gubun = "N";
		
	//acms 테이블에서 입금미반영된 출금의뢰일 조회하기
	Vector vt = af_db.getACmsDate();
	int vt_size = vt.size();	
	
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>

<input type='hidden' name='incom_dt' value='<%=incom_dt%>'>
<input type='hidden' name='incom_seq' value='<%=incom_seq%>'>
<input type='hidden' name='incom_amt' value='<%=incom_amt%>'>
<input type='hidden' name='v_gubun' value='<%=v_gubun%>'>

<table border="0" cellspacing="0" cellpadding="0" width=400>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						CMS 입금 등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	
    <tr>
        <td class=line2></td>
    </tr>
  
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        		<tr>
        		  <td width='100' class='title'>출금의뢰일자</td>
        		  <td width='300' >&nbsp;
        <%	if(vt_size > 0){%>						  
                      <select name="adate">
        <%		for(int i = 0 ; i < vt_size ; i++){
        			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                        <option value="<%=ht.get("ADATE")%>"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ADATE")))%></option>
        <%		}%>
                      </select>			
        
        <%	}else{%>
         입금반영이 되지 않은 출금의뢰일자는 없습니다.
         <input type='hidden' name='adate' value=''>
        <%	}%>
        		  </td>
        		</tr>
	        </table>
	    </td>
    </tr>
   
 
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>