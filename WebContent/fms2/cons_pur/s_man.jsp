<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="cons_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");


	String off_id 		= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String dlv_ext 		= request.getParameter("dlv_ext")==null?"":request.getParameter("dlv_ext");
	
	
	

	Vector vt = cons_db.getPurManSearch(off_id, car_comp_id, dlv_ext, s_kd, t_wd);

	
	int vt_size = vt.size();
	
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
		
	function Disp(nm, ssn, m_tel){
		var fm = document.form1;
		opener.form1.driver_nm.value 		= nm;
		opener.form1.driver_ssn.value 		= ssn;
		opener.form1.driver_m_tel.value 	= m_tel;
		self.close();
	}			
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_man.jsp'>
  <input type='hidden' name='off_id' value='<%=off_id%>'>    
  <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>      
  <input type="hidden" name="dlv_ext" value="<%=dlv_ext%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;		 
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
            </select>&nbsp;
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=whitetext onKeyDown="javasript:enter()" style='IME-MODE: active'>
            <input type="button" name="b_ms2" value="검색" onClick="javascript:search();" class="btn">
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="10%">연번</td>
                    <td class=title width="10%">구분</td>
                    <td class=title width="40%">운전자명</td>
                    <td class=title width="40%">핸드폰번호</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=ht.get("ST")%></td>
                    <td><a href="javascript:Disp('<%=ht.get("NM")%>', '<%=ht.get("SSN")%>', '<%=ht.get("M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("NM")%></a></td>
                    <td><%=ht.get("M_TEL")%></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
        <td>※ 지정 출고대리인과 최근 1달 동안 탁송배정된 운전자 리스트입니다.</td>
    </tr>
    <tr> 
        <td align="center">
	        <a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		
	    </td>
    </tr>
</table>
</form>
</body>
</html>