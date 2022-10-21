<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
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
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	if(s_kd.equals("5")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = as_db.getAccidS2List(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int accid_size = accids.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='accid_size' value='<%=accid_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1250'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='43%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>					
                    <td width='13%' class='title'>연번</td>
                    <td width='12%' class='title'>처리구분</td>
                    <td width='12%' class='title'>사고유형</td>
        		    <td width='20%' class='title'>계약번호</td>
        		    <td width='26%' class='title'>상호</td>
        		    <td width='17%' class='title'>차량번호</td>
        		</tr>
    	    </table>
	    </td>
	    <td class='line' width='57%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td width='20%' class='title'>사고일시</td>
                <td width='9%' class='title'>인적구분</td>
                <td width='9%' class='title'>부상구분</td>			
                <td width='15%' class='title'>성명</td>
                <td width='20%' class='title'>병원</td>
                <td width='27%' class='title'>부상정도</td>
              </tr>
            </table>
	    </td>
    </tr>
<%	if(accid_size > 0){%>
    <tr>
	    <td class='line' width='43%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<% 		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>
        		<tr>					
                    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='13%' align='center'><a name="<%=i+1%>"><%=i+1%><%if(accid.get("USE_YN").equals("Y")){%><%}else{%>(해약)<%}%></a></td>
                    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='12%' align='center'> 
                      <%if(String.valueOf(accid.get("ONE_ACCID_ST_NM")).equals("자손") && String.valueOf(accid.get("SETTLE_ST3")).equals("1")){%>
                      종결
                      <%}else if(String.valueOf(accid.get("ONE_ACCID_ST_NM")).equals("자손") && String.valueOf(accid.get("SETTLE_ST3")).equals("0")){%>
                      <font color="#FF6600">진행</font> 
                      <%}else if(String.valueOf(accid.get("ONE_ACCID_ST_NM")).equals("대인") && String.valueOf(accid.get("SETTLE_ST1")).equals("1")){%>
                      종결		  
                      <%}else{%>
                      <font color="#FF6600">진행</font> 			  			  
                      <%}%>
                    </td>
                    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='12%' align='center'><%=accid.get("ACCID_ST_NM")%></td>
        		    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='20%' align='center'><a href="javascript:parent.AccidentDisp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("ACCID_ID")%>', '<%=accid.get("ACCID_ST")%>', '<%=i%>')" onMouseOver="window.status=''; return true"><%=accid.get("RENT_L_CD")%></a></td>
        		    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='26%' align='center'><span title='<%=accid.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(accid.get("FIRM_NM")), 8)%></a></span></td>
        		    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='17%' align='center'><%=accid.get("CAR_NO")%></td>
        		</tr>
<%		}%>
	        </table>
	    </td>
	    <td class='line' width='57%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < accid_size ; i++){
    			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                <tr> 
                    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='20%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>
                    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='9%' align='center'><%=accid.get("ONE_ACCID_ST_NM")%></td>
                    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='9%' align='center'><%=accid.get("WOUND_ST_NM")%></td>			
                    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='15%' align='center'><span title='<%=accid.get("NM")%>'><%=Util.subData(String.valueOf(accid.get("NM")), 11)%></span></td>
                    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='20%' align='center'><span title='<%=accid.get("HOSP")%>'><%=Util.subData(String.valueOf(accid.get("HOSP")), 11)%></span></td>
                    <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='27%'>&nbsp;<span title='<%=accid.get("DIAGNOSIS")%>'><%=Util.subData(String.valueOf(accid.get("DIAGNOSIS")), 11)%></span></td>
                </tr>
    <%		}%>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='43%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        		    <td align='center'>등록된 데이타가 없습니다</td>
        		</tr>
	        </table>
	    </td>
	    <td class='line' width='57%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
    		        <td>&nbsp;</td>
    		    </tr>
    	    </table>
	    </td>
    </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
/*	var fm 		= document.form1;
	var p_fm	= parent.form1;
	var cnt 	= fm.fee_size.value;
	
	var i_amt = 0;
	
	if(cnt > 1){
		for(var i = 0 ; i < cnt ; i++){
			i_amt   += toInt(parseDigit(fm.amt[i].value));
		}
	}else if(cnt == 1){
		i_amt   += toInt(parseDigit(fm.amt.value));	
	}		*/
-->
</script>
</form>
</body>
</html>
