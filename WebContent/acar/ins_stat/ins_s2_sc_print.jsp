<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"3":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector inss = ai_db.getInsStatList1(br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int ins_size = inss.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='ins_size' value='<%=ins_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='900'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='100%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='60' class='title'>연번</td>
                    <td width='100' class='title'>계약번호</td>
                    <td width='110' class='title'>상호</td>
                    <td width='90' class='title'>차량번호</td>
                    <td width='150' class='title'>차대번호</td>					
                    <td width='130' class='title'>차명</td>
                    <td width='60' class='title'>차종</td>					
                    <td width='60' class='title'>보험회사</td>
                    <td width='70' class='title'>보험시작일</td>
                    <td width='70' class='title'>보험만료일</td>						
                </tr>
            </table>
	    </td>
    </tr>
<%	if(ins_size > 0){%>
    <tr>
	    <td class='line' width='100%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><a name="<%=i+1%>"><%=i+1%> 
                      <%if(ins.get("USE_YN").equals("Y")){%>
                      <%}else{%>
                      (해약) 
                      <%}%>
                      </a></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><%=ins.get("RENT_L_CD")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='110' align='center'><%=ins.get("FIRM_NM")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><%=ins.get("CAR_NO")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='150' align='center'><%=ins.get("CAR_NUM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='130' align='center'><%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><%=ins.get("CAR_KD")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><%=ins.get("INS_COM_NM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
                </tr>
              <%		}%>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='100%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
    		        <td align='center'>등록된 데이타가 없습니다</td>
    		    </tr>
    	    </table>
	    </td>
    </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</form>
</body>
</html>
