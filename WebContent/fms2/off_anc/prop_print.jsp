<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String use_yn = request.getParameter("use_yn")==null?"1":request.getParameter("use_yn");
	
	int count = 0;
		
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	
	//보류 혹은 제안대상기간
	Hashtable res = p_db.getPropResCase(AddUtil.getDate());
	
	gubun1	= "2";
	//st_dt 	= String.valueOf(res.get("START_DT"));
	//end_dt 	= String.valueOf(res.get("END_DT"));
	s_kd	= "";
	t_wd	= "";
	gubun2	= "";
	gubun3	= "1";
	gubun4	= "";
	use_yn	= "";
		
	
	Vector vt = p_db.getOffPropListPrint(s_kd, t_wd, gubun1, st_dt, end_dt, gubun2, gubun3, gubun4, user_id);
	int vt_size = vt.size();
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<style type="text/css">
<!--
.styleB {
	font-weight: bold;
	font-size: 15pt
}
-->
</style>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<center>
  <table border="0" cellspacing="0" cellpadding="0" width='600'>
    <tr>
        <td align="center"><span class=styleB>< <%=AddUtil.getDate()%> 제안심사 회의 >
        </span></td>
    </tr>  
 
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class='line2'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='30' class='title'>순번</td>
		    <td width="80" class='title'>이름/날짜</td>			
		    <td width='450'class='title'>제목/내용</td>
		    <td width="40" class='title'>채택</td>
		  </tr>
		
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
          <tr >
            <td rowspan="2" align="center"><%=i+1%></td>              											
            <td rowspan="2" align="center">
            <% if ( String.valueOf(ht.get("OPEN_YN")).equals("Y")   ) { %><%=String.valueOf(ht.get("USER_NM"))%>
			<% } else {  %>
			비공개 
			<% } %><br>(<%=String.valueOf(ht.get("REG_DT"))%>)</td>	         
            <td><%=ht.get("TITLE")%></td>
            <td rowspan="2" align="center">&nbsp;</td>
		  </tr>
		  <tr>
		  <td>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;</td>
		  </tr>
        
<%		}%>
		</table>
	  </td>
    </tr>	  
  </table>
</center>  
<script language="JavaScript" type="text/JavaScript">
function onprint(){
factory.printing.header 		= ""; //폐이지상단 인쇄
factory.printing.footer 		= ""; //폐이지하단 인쇄
factory.printing.portrait 		= true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin 	= 15.0; //좌측여백   
factory.printing.rightMargin 	= 15.0; //우측여백
factory.printing.topMargin 		= 20.0; //상단여백    
factory.printing.bottomMargin 	= 15.0; //하단여백
//factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>
</body>
</html>