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
<body onLoad="javascript:init()">
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
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
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
	
	
	
	Vector inss = ai_db.getInsAmtList(br_id, gubun0, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int ins_size = inss.size();
	
	int width1 = 540;
	int width2 = 560;
	
	long total_amt = 0;
%>


<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='ins_size' value='<%=ins_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='35%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='16%' class='title'>연번</td>
                    <td width='12%' class='title'>지출구분</td>
                    <td width='12%' class='title'>보험종류</td>
                    <td width='12%' class='title'>보험상태</td>			
                    <td width='19%' class='title'>차량번호</td>
                    <td width='24%' class='title'>차명</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='65%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>     
                    <td width='14%' class='title'>보험회사</td>
                    <td width='16%' class='title'>증권번호</td>
                    <td width='10%' class='title'>보험구분</td>
                    <td width='15%' class='title'>보험료구분</td>
                    <td width='7%' class='title'>회차</td>									
                    <td width='10%' class='title'><%if(gubun4.equals("2")){%>청구일<%}else{%>납부예정일<%}%></td>
                    <td width='10%' class='title'>보험료</td>
                    <td width='10%' class='title'><%if(gubun4.equals("2")){%>입금일<%}else{%>납부일<%}%></td>
                    <td width='8%' class='title'>지출</td>						
                </tr>
            </table>
	    </td>
    </tr>
<%	if(ins_size > 0){%>
    <tr>
	    <td class='line' width='35%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='16%' align='center'><a name="<%=i+1%>"><%=i+1%></a>&nbsp;<%if(ins.get("USE_YN").equals("N")){%><span title='명의이전일:<%=AddUtil.ChangeDate2(String.valueOf(ins.get("MIGR_DT")))%>'>(매각)</span><%}%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='12%' align='center'><%=ins.get("PAY_YN")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='12%' align='center'><%=ins.get("INS_KD")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='12%' align='center'><%=ins.get("INS_STS")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='19%' align='center'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='24%' align='center'><span title='<%=ins.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 7)%></span></td>
                </tr>
              <%		}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" align='center'>합계</td>
                    <td class="title">&nbsp;</td>
                </tr>			  
            </table>
	    </td>
	    <td class='line' width='65%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='14%' align='center'><span title='<%=ins.get("INS_COM_NM")%>'><%=Util.subData(String.valueOf(ins.get("INS_COM_NM")), 5)%></span></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='16%' align='center'><%=ins.get("INS_CON_NO")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='10%' align='center'><%=ins.get("TM1")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='15%' align='center'><%=ins.get("TM2")%></td>			
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='7%' align='center'><%=ins.get("INS_TM")%>회</td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='10%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("R_INS_EST_DT")))%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='10%' align="right"><%=Util.parseDecimal(String.valueOf(ins.get("PAY_AMT")))%>원&nbsp;</td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='10%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("PAY_DT")))%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='8%' align='center'>
        			<%if(String.valueOf(ins.get("PAY_DT")).equals("")){%>
        			<a href="javascript:parent.insScd('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>', '<%=ins.get("INS_TM")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_jc.gif align=absmiddle border=0></a></td>
        			<%}else{%>-<%}%>
                </tr>
              <%		total_amt  = total_amt  + Long.parseLong(String.valueOf(ins.get("PAY_AMT"))==null?"0":String.valueOf(ins.get("PAY_AMT")));
			  		}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>                    
                    <td class="title" colspan='2' style='text-align:right'><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                </tr>			  			  
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td colspan="2" align='center' class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align="center">등록된 데이타가 없습니다.</td>
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
