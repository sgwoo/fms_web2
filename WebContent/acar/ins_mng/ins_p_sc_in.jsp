<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

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
	if(s_kd.equals("5")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	if(t_wd.equals("") && !s_kd.equals("6")) return;
	
	Vector inss = ai_db.getInsMngCostList(br_id, gubun0, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int ins_size = inss.size();
	
	int width1 = 600;
	int width2 = 500;
	
	if(gubun3.equals("4"))	width2 = 700;
	if(gubun3.equals("5"))	width2 = 420;
	if(gubun3.equals("6"))	width2 = 440;
	
	long total_amt1 = 0;	
	long total_amt2 = 0;	
	long total_amt3 = 0;	
	long total_amt4 = 0;	
%>

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


<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='ins_size' value='<%=ins_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='30%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='10%' class='title'>연번</td>
                    <td width='17%' class='title'>보험<br>종류</td>
                    <td width='17%' class='title'>보험<br>상태</td>
                    <td width='24%' class='title'>차량번호</td>
                    <td width='32%' class='title'>차명</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='70%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='10%' class='title'>보험회사</td>
                    <td width='6%' class='title'>용도</td>			
                    <td width='15%' class='title'>보험기간</td>
                    <td width='9%' class='title'>가입<br>변경일</td>					
                    <td width='10%' class='title'>해지일<br>(청구일)</td>
                    <td width='9%' class='title'>기간<br>비용일</td>					
                    <td width='9%' class='title'>총<br>보험료</td>
                    <td width='8%' class='title'>변경<br>금액</td>
                    <td width='8%' class='title'>해지<br>환급액</td>										
                    <td width='8%' class='title'>기간비용<br>합</td>						
                    <td width='8%' class='title'>차액</td>					
                </tr>
            </table>
	    </td>
    </tr>
<%	if(ins_size > 0){%>
    <tr>
	    <td class='line' width='30%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    						Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='10%' align='center'><a name="<%=i+1%>"><%=i+1%></a><!--&nbsp;<%if(ins.get("USE_YN").equals("N")){%><span title='명의이전일:<%=AddUtil.ChangeDate2(String.valueOf(ins.get("MIGR_DT")))%>'>(매각)</span><%}%>--></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='17%' align='center'><%=ins.get("INS_KD")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='17%' align='center'><%=ins.get("INS_STS")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='24%' align='center'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>', '<%=ins.get("CHA_AMT")%>')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='32%' align='center'><span title='<%=ins.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 6)%></span></td>
                </tr>
              <%		}%>
                <tr> 
                    <td class="title" colspan='5'>&nbsp;</td>
                </tr>					  
            </table>
	    </td>
	    <td class='line' width='70%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_size ; i++){
    						Hashtable ins = (Hashtable)inss.elementAt(i);
							
							total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ins.get("PAY_AMT")));
							total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ins.get("CH_AMT")));
							total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ins.get("RTN_AMT")));
							total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ins.get("CHA_AMT")));
							%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='10%' align='center'><%=ins.get("INS_COM_NM")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='6%' align="center"><%=ins.get("CAR_USE")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='15%' align="center"><%=ins.get("INS_START_DT")%>~<%=ins.get("INS_EXP_DT")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='9%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("CH_DT")))%></td>					
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='10%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("REQ_DT")))%></td>					
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='9%' align="center"><%=ins.get("COST_YM")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='9%' align='right'><%=Util.parseDecimal(String.valueOf(ins.get("PAY_AMT")))%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='8%' align='right'><font color=green><%=Util.parseDecimal(String.valueOf(ins.get("CH_AMT")))%></font></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='8%' align='right'><font color=green><%=Util.parseDecimal(String.valueOf(ins.get("RTN_AMT")))%></font></td>					
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='8%' align='right'><%=Util.parseDecimal(String.valueOf(ins.get("COST_AMT")))%></td>					
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='8%' align='right'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>', '<%=ins.get("CHA_AMT")%>')" onMouseOver="window.status=''; return true"><font color=red><%=Util.parseDecimal(String.valueOf(ins.get("CHA_AMT")))%></font></a></td>
                </tr>
              <%		}%>
                <tr> 
                    <td class="title" colspan='6'>합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>													
                    <td class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>													
                </tr>			  
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td colspan="2" align='center'>등록된 데이타가 없습니다</td>
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
