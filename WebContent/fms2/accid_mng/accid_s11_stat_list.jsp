<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.cont.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String ins_com 	= request.getParameter("ins_com")==null?"":request.getParameter("ins_com");
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector vt = as_db.getMyAccidInsComDtStatList2(ins_com, s_yy, s_mm);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_pay_amt = 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//세부리스트
	function view_stat(m_id, l_cd, c_id, accid_id){
		var fm = document.form1;
		
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;
				
		fm.action = '/acar/accid_mng/accid_u_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
  <input type='hidden' name='m_id' 		value=''>
  <input type='hidden' name='l_cd' 		value=''>
  <input type='hidden' name='c_id' 		value=''>
  <input type='hidden' name='accid_id' 		value=''>
  <input type='hidden' name='mode' 		value='8'>
<table border=0 cellspacing=0 cellpadding=0 width=800>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><%=ins_com%></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td width=50 class=title>연번</td>
                    <td width=100 class=title>차량번호</td>					
                    <td width=150 class=title>사고일시</td>					
                    <td width=100 class=title>청구일자</td>
                    <td width=100 class=title>청구금액</td>
                    <td width=100 class=title>입금일자</td>
                    <td width=100 class=title>입금금액</td>
                    <td width=100 class=title>-</td>
					
                </tr>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
			//	Hashtable ext66 = a_db.getScdExtEtcPay(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), "6", String.valueOf(ht.get("ACCID_ID"))+""+String.valueOf(ht.get("SEQ_NO")));
			//	if(AddUtil.parseInt(String.valueOf(ext66.get("PAY_AMT")))>0){
			//			total_pay_amt = AddUtil.parseInt(String.valueOf(ext66.get("PAY_AMT")));
			//	}
				
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("REQ_AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
				//total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ext66.get("PAY_AMT")));
		%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>			
                    <td align="center"><%=ht.get("ACCID_DT")%></td>
                    <td align="center"><%=ht.get("REQ_DT")%></td>
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("REQ_AMT")))%></td>
                    <td align="center"><%=ht.get("PAY_DT")%></td>
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("PAY_AMT")))%><%//=Util.parseDecimal(total_pay_amt)%></td>
                    <td align="center"><a href="javascript:view_stat('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>')" onMouseOver="window.status=''; return true">보기</a></td>
                </tr>		
		<%	}%>	
                <tr> 
                    <td class="title" colspan='3'>합계</td>
                    <td class="title"></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
                    <td class="title"></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
                    <td class="title"></td>
                </tr>																				
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>