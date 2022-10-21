<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acct.* "%>
<jsp:useBean id="at_db" scope="page" class="acct.AcctDatabase"/>
<%@ include file="/acct/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");


	String gubun1 	= request.getParameter("gubun1") ==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2") ==null?"":request.getParameter("gubun2");
	
		
	Vector vt = at_db.getValueMngList(gubun1, gubun2);
	int vt_size = vt.size();

	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//세부리스트
	function view_acct(save_dt, acct_st, s_dt, e_dt, seq){
		window.open('acct_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt='+save_dt+'&acct_st='+acct_st+'&s_dt='+s_dt+'&e_dt='+e_dt+'&seq='+seq, "VIEW_ACCT", "left=0, top=0, width=900, height=568, scrollbars=yes, status=yes, resize");
	}
	
	//초기화면가기
	function f_init()
	{
		var fm = document.form1;
		fm.target = "_self";
		fm.action = "value_sc.jsp";	
		fm.submit();
	}		
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = theURL;
		window.open(theURL,winName,features);
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td class=line2></td>
    </tr>    
    <tr> 
      <td class=line> 
        <table width=100% border="0" cellspacing="1" cellpadding="0">     
          <tr> 
            <td width=5% class=title>연번</td>
            <td width=12% class=title>비지니스사이클</td>				            
            <td width=15% class=title>서브프로세스</td>
            <td width=13% class=title>평가기간</td>
            <td width=7% class=title>확인자</td>
            <td width=8% class=title>확인결과</td>
            <td width=5% class=title>파일</td>
            <td width=10% class=title>value1</td>
            <td width=10% class=title>value2</td>
            <td width=10% class=title>value3</td>            
            <td width=5% class=title>-</td>            
          </tr>  
          <%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	  <tr>
	    <td align="center"><%=i+1%></td>
	    <td align='center'><%=ht.get("CYCLE_NM")%></td>            
	    <td align='center'><%=ht.get("PROCESS_NM")%></td>            
            <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("S_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("E_DT")))%></td>	    
            <td align='center'><%=ht.get("APP_NM")%></td>	    
            <td align='center'>
              <%if(String.valueOf(ht.get("RESULT")).equals("Y")){%>
                적합
              <%}else if(String.valueOf(ht.get("RESULT")).equals("N")){%>
                부적합
              <%}%>
            </td>     
            <td align='center'>
              <%if(!String.valueOf(ht.get("ATT_FILE")).equals("")){%>
                 <a href="javascript:MM_openBrWindow('<%=ht.get("ATT_FILE")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')">보기</a> 
              <%}else{%>  
                -
              <%}%>
            </td>
            <td align='center'><%=ht.get("VALUE1")%></td>
            <td align='center'><%=ht.get("VALUE2")%></td>
            <td align='center'><%=ht.get("VALUE3")%></td>
            <td align='center'><a href="javascript:view_acct('<%=ht.get("SAVE_DT")%>','<%=ht.get("ACCT_ST")%>','<%=ht.get("S_DT")%>','<%=ht.get("E_DT")%>','<%=ht.get("SEQ")%>')">[보기]</a></td>
	  </tr>			
	  <%	}%>		
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>