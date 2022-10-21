<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String id = request.getParameter("id")==null?"000000":request.getParameter("id");//client_id
	if(id.equals("")) id = "000000";

	apprsl = olpD.getPre_apprsl(car_mng_id);
	Vector docs = olpD.getDocs(id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
var checkflag = "false";
function AllSelect(field){
	if(checkflag == "false"){
		for(i=0; i<field.length; i++){
			field[i].checked = true;
		}
		checkflag = "true";
		return;
	}else{
		for(i=0; i<field.length; i++){
			field[i].checked = false;
		}
		checkflag = "false";
		return;
	}
}
function doc_chk(ioru){
	var fm = document.form1;
	if(ioru=="i"){
		if(!confirm('등록 하시겠습니까?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('수정 하시겠습니까?')){ return; }
	}
	fm.gubun.value = ioru;
	fm.target="i_no";
	fm.action="/acar/off_ls_pre/off_ls_pre_actn_up.jsp";
	fm.submit();
}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="flag" value="no_open">
<input type="hidden" name="gubun" value="">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>구비서류</span>
            <select name='doc_chk'>
              <option value=''>선택</option>
              <option value='N' <%if(olpD.getDoc_chk(car_mng_id).equals("N")){%>selected<%}%>>미비</option>
              <option value='Y' <%if(olpD.getDoc_chk(car_mng_id).equals("Y")){%>selected<%}%>>완료</option>
            </select>
            &nbsp; 
            <%if(auth_rw.equals("4")||auth_rw.equals("6")){
			  		if(apprsl.getDoc_seq().equals("")){%>
            <a href='javascript:doc_chk("i");'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
            <%	}else{%>
            <a href='javascript:doc_chk("u");'><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
            <%	}
			  }%>
          </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line" width="100%">
            <table border="0" cellspacing="1" cellpadding="0" width="100%">        
        <tr> 
          <td class=title width="30"> 
            <input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'>
          </td>
          <td class=title width="40">연번</td>
          <td class=title width="300">서류명</td>
        </tr>
        <input type="hidden" name="doc_mode" value="">
        <%
				Vector vt = new Vector();
				StringTokenizer st = new StringTokenizer(apprsl.getDoc_seq(),"/",true);
				int k = 0;
				String[] seq = new String[st.countTokens()];
				while(st.hasMoreTokens()){
					String token = st.nextToken();
					seq[k] = token;
					k++;
				}
				for(int i=0; i<docs.size(); i++){
				Hashtable ht = (Hashtable)docs.elementAt(i);%>
        <tr> 
          <td align='center' width="30"> 
            <input type="checkbox" name="pr" value="<%=ht.get("SEQ")%>" 
						<%for(int j=0; j<seq.length; j++){
							if(seq[j].equals(ht.get("SEQ"))){%> checked <%}
						  }%>	>
          </td>
          <td align='center' width="40"><%=i+1%></td>
          <td align='left' width="300"> &nbsp; &nbsp; 
            <input type='text' name='doc_nm'    size='30' maxlength='40' class='whitetext' value="<%=ht.get("DOC_NM")%>" readonly>
          </td>
        </tr>
        <%}%>
      </table>
</td>
</tr>
</table>
</form>
</body>
</html>
