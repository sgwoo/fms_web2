<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="e_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = e_db.getContBcExtList();
	int cont_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--

//-->
</script>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width='600'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line' > 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='50' class='title'>연번</td>
                    <td width='150' class='title'>계약관리번호</td>
                    <td width="150" class='title'>계약번호</td>
                    <td width='100' class='title'>연장관리번호</td>
                    <td width="150" class='title'>차량관리번호</td>
                </tr>            
            <%	for(int i = 0 ; i < cont_size ; i++){
    							Hashtable ht = (Hashtable)vt.elementAt(i);
    	    %>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("RENT_MNG_ID")%></td>
        		        <td align='center'>
        		        	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("계약결재",user_id) || nm_db.getWorkAuthUser("관리자모드",user_id) || nm_db.getWorkAuthUser("차종관리",user_id)){%>     
        		        	<a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true" title='계약약식내역'><%=ht.get("RENT_L_CD")%></a>
        		        	<%}%>
        		        </td>
        		        <td align='center'><%=ht.get("RENT_ST")%></td>                    
        		        <td align='center'><%=ht.get("CAR_MNG_ID")%></span></td>
                </tr>
                <%		}	%>
            </table>
    	</td>

</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>


