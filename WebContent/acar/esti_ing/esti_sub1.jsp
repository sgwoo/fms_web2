<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.esti_mng.*" %>
<jsp:useBean id="EstiMngDb" class="acar.esti_mng.EstiMngDatabase" scope="page" />
<jsp:useBean id="EstiRegBn" class="acar.esti_mng.EstiRegBean" scope="page"/>
<jsp:useBean id="EstiListBn" class="acar.esti_mng.EstiListBean" scope="page"/>
<jsp:useBean id="EstiContBn" class="acar.esti_mng.EstiContBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String est_st = request.getParameter("est_st")==null?"":request.getParameter("est_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();
	
	EstiContBn = EstiMngDb.getEstiCont(est_id, seq);
	
//	String reg_id = "";
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body onload="javascript:document.form1.title.focus();">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="./esti_sub_a.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
    <input type="hidden" name="gubun5" value="<%=gubun5%>">    
    <input type="hidden" name="gubun6" value="<%=gubun6%>">    	
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="s_year" value="<%=s_year%>">
    <input type="hidden" name="s_mon" value="<%=s_mon%>">
    <input type="hidden" name="s_day" value="<%=s_day%>">	
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="seq" value="<%=seq%>">	
	<input type="hidden" name="est_st" value="<%=est_st%>">		
    <input type="hidden" name="sub_st" value="1">
    <input type="hidden" name="cmd" value="">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=11%>등록일자</td>
                    <td width=39%>
                        &nbsp;<input type='text' name='reg_dt' value='<%=Util.getDate()%>' size='11' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'>
        			    <%if(est_st.equals("2")){%>
                         &nbsp;<input type="checkbox" name="est_cng" value="1">
                        보류해제 <font color="#999999">(보류중일때)</font>
        			    <%}%>			  
        		    </td>
                    <td class=title width=11%>등록자</td>
                    <td width=39%>
                         &nbsp;<select name="reg_id">
                            <option value="">전체</option>
                            <%	if(user_size > 0){
            							for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                            <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                            <%		}
            					}		%>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>제목</td>
                    <td colspan="3"> 
                         &nbsp;<input type="text" name="title" value="" size="100" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>진행내용</td>
                    <td colspan="3"> 
                         &nbsp;<textarea name="cont" cols=152 rows=5 class=default></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
	    <%if(seq.equals("")){%>
	    <a href="javascript:parent.EstiReg();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%}else{%>	  
	    <a href="javascript:parent.EstiContUpd();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	    <%}%>	  	  
	    </td>
    </tr>	
</form>
</table>
</body>
</html>