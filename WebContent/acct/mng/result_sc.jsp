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
	
	String s_dt 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 	= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");	
	String seq 	= request.getParameter("seq")		==null?"":request.getParameter("seq");	
	
	Vector vt = new Vector();
	int vt_size = 0;
		
		
	if(gubun1.equals("") && gubun2.equals("")){	
	
	}else{
		vt = at_db.getResultMngList(gubun1, gubun2);
		vt_size = vt.size();
	}
	
	String acc_st_nm = "";
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
		fm.action = "result_sc.jsp";	
		fm.submit();
	}		
	
	//프린트하기
	function Print(st, nm, vl1, vl2, vl3, vl4, vl5, vl6, vl7, vl8, vl9, vl10, vl11, vl12, vl13, vl14, vl15, vl16, vl17, vl18, vl19, vl20 )
	{
		var fm = document.form1;
	//	if(<%//=vt_size%> == 0)		{ alert('검색데이타가 없습니다. 먼저 검색하여 주십시오.'); 	fm.st_dt.focus(); 	return; }	
		//fm.cmd.value="p";
		fm.target = "_blank";
		fm.action = "/acct/"+nm+"/"+st+"_print.jsp?value1="+vl1+"&value2="+vl2+"&value3="+vl3+"&value4="+vl4+"&value5="+vl5+"&value6="+vl6+"&value7="+vl7+"&value8="+vl8+"&value9="+vl9+"&value10="+vl10+"&value11="+vl11+"&value12="+vl12+"&value13="+vl13+"&value14="+vl14+"&value15="+vl15+"&value16="+vl16+"&value17="+vl17+"&value18="+vl18+"&value19="+vl19+"&value20="+vl20;	
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
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			acc_st_nm = (String)ht.get("ACCT_ST");
			acc_st_nm = acc_st_nm.substring(0,2);
			
			%>
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
                있음
              <%}else{%>  
                -
              <%}%>
            </td>
            <td align='center'><%=ht.get("VALUE1")%></td>
            <td align='center'><%=ht.get("VALUE2")%></td>
            <td align='center'><%=ht.get("VALUE3")%></td>
            <td align='center'><a href="javascript:view_acct('<%=ht.get("SAVE_DT")%>','<%=ht.get("ACCT_ST")%>','<%=ht.get("S_DT")%>','<%=ht.get("E_DT")%>','<%=ht.get("SEQ")%>')">[보기]</a> <a href="javascript:Print('<%=ht.get("ACCT_ST")%>','<%=acc_st_nm%>','<%=ht.get("VALUE1")%>','<%=ht.get("VALUE2")%>','<%=ht.get("VALUE3")%>','<%=ht.get("VALUE4")%>','<%=ht.get("VALUE5")%>','<%=ht.get("VALUE6")%>','<%=ht.get("VALUE7")%>','<%=ht.get("VALUE8")%>','<%=ht.get("VALUE9")%>','<%=ht.get("VALUE10")%>','<%=ht.get("VALUE11")%>','<%=ht.get("VALUE12")%>','<%=ht.get("VALUE13")%>','<%=ht.get("VALUE14")%>','<%=ht.get("VALUE15")%>','<%=ht.get("VALUE16")%>','<%=ht.get("VALUE17")%>','<%=ht.get("VALUE18")%>','<%=ht.get("VALUE19")%>','<%=ht.get("VALUE20")%>');">P</a></td>

				<input type='hidden' name='st_dt' 		value='<%=ht.get("S_DT")%>'>
				<input type='hidden' name='end_dt' 		value='<%=ht.get("E_DT")%>'>
				<input type='hidden' name='s_cnt' 		value='1'> 
				<input type='hidden' name="value1" 		value="<%=ht.get("VALUE1")%>">
				<input type='hidden' name="value2" 		value="<%=ht.get("VALUE2")%>">
				<input type='hidden' name="value3" 		value="<%=ht.get("VALUE3")%>">
				<input type='hidden' name="value4" 		value="<%=ht.get("VALUE4")%>">
				<input type='hidden' name="value5" 		value="<%=ht.get("VALUE5")%>">
				<input type='hidden' name="value6" 		value="<%=ht.get("VALUE6")%>">
				<input type='hidden' name="value7" 		value="<%=ht.get("VALUE7")%>">			
				<input type='hidden' name="value8" 		value="<%=ht.get("VALUE8")%>">
				<input type='hidden' name="value9" 		value="<%=ht.get("VALUE9")%>">
				<input type='hidden' name="value10" 	value="<%=ht.get("VALUE10")%>">
				<input type='hidden' name="value11" 	value="<%=ht.get("VALUE11")%>">
				<input type='hidden' name="value12" 	value="<%=ht.get("VALUE12")%>">
				<input type='hidden' name="value13" 	value="<%=ht.get("VALUE13")%>">
				<input type='hidden' name="value14" 	value="<%=ht.get("VALUE14")%>">
				<input type='hidden' name="value15" 	value="<%=ht.get("VALUE15")%>">
				<input type='hidden' name="value16" 	value="<%=ht.get("VALUE16")%>">
				<input type='hidden' name="value17" 	value="<%=ht.get("VALUE17")%>">			
				<input type='hidden' name="value18" 	value="<%=ht.get("VALUE18")%>">
				<input type='hidden' name="value19" 	value="<%=ht.get("VALUE19")%>">
				<input type='hidden' name="value20" 	value="<%=ht.get("VALUE20")%>">
			  
	  </tr>			
	  <%	}%>		
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>