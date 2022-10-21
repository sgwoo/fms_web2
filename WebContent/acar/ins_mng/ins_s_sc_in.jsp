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
	if(s_kd.equals("5")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector inss = ai_db.getInsMngList(br_id, gubun0, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int ins_size = inss.size();
	
	int width1 = 600;
	int width2 = 500;
	
	if(gubun3.equals("4"))	width2 = 700;
	if(gubun3.equals("5"))	width2 = 420;
	if(gubun3.equals("6"))	width2 = 440;
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='ins_size' value='<%=ins_size%>'>
<%	if(gubun3.equals("") || gubun3.equals("1") || gubun3.equals("2")){%>
<table border="0" cellspacing="0" cellpadding="0" width=1250>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='400' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='50' class='title'>연번</td>
                    <td width='70' class='title'>보험종류</td>
                    <td width='70' class='title'>보험상태</td>
                    <td width='90' class='title'>차량번호</td>
                    <td width='120' class='title'>차명</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='890'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='98' class='title'>보험회사</td>
                    <td width='60' class='title'>용도</td>			
                    <td width='154' class='title'>증권번호</td>			
                    <td width='161' class='title'>보험기간</td>
                    <td width='80' class='title'>가입일자</td>					
                    <td width='78' class='title'>해지일자</td>					
                    <td width='117ㄴ' class='title'>가입연령</td>
                    <td width='58' class='title'>에어백</td>
                    <td width='63' class='title'>갱신</td>
                    <td width='62' class='title'>해지</td>						
                </tr>
            </table>
	    </td>
    </tr>
<%	}else if(gubun3.equals("4")){%>
<table border="0" cellspacing="0" cellpadding="0" width='1300'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='35%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='16%' class='title'>연번</td>
                    <td width='15%' class='title'>보험종류</td>
                    <td width='15%' class='title'>보험상태</td>
                    <td width='20%' class='title'>차량번호</td>
                    <td width='34%' class='title'>차명</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='65%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='12%' class='title'>보험회사</td>
                    <td width='8%' class='title'>용도</td>			
                    <td width='23%' class='title'>보험기간</td>
                    <td width='12%' class='title'>변경일</td>
                    <td width='14%' class='title'>변경항목</td>
                    <td width='15%' class='title'>변경전</td>
                    <td width='16%' class='title'>변경후</td>						
                </tr>
            </table>
	    </td>
    </tr>
<%	}else if(gubun3.equals("3") || gubun3.equals("7")){%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
    	<td class='line' width='50%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='16%' class='title'>연번</td>
                    <td width='15%' class='title'>용도변경</td>
                    <td width='15%' class='title'>해지목적</td>
                    <td width='20%' class='title'>차량번호</td>
                    <td width='34%' class='title'>차명</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='50%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='17%' class='title'>보험회사</td>
                    <td width='13%' class='title'>용도</td>			
                    <td width='30%' class='title'>보험기간</td>
                    <td width='21%' class='title'>해지사유발생일</td>
                    <td width='19%' class='title'>청구일</td>
                </tr>
            </table>
    	</td>
    </tr>  
<%	}else if(gubun3.equals("5")){%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='55%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='16%' class='title'>연번</td>
                    <td width='15%' class='title'>가입사유</td>
                    <td width='20%' class='title'>차량번호</td>
                    <td width='27%' class='title'>차대번호</td>			
                    <td width='22%' class='title'>차명</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='45%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='25%' class='title'>가입사유발생일</td>
                    <td width='60%' class='title'>기타</td>			
                    <td width='15%' class='title'>가입</td>
                </tr>
            </table>
	    </td>
    </tr>  
<%	}else if(gubun3.equals("6")){%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
    	<td class='line' width='50%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                	  <td width='10%' class='title'><input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'></td>
                    <td width='15%' class='title'>연번</td>
                    <td width='15%' class='title'>해지사유</td>
                    <td width='20%' class='title'>차량번호</td>
                    <td width='40%' class='title'>차명</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='50%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='20%' class='title'>보험회사</td>
                    <td width='15%' class='title'>용도</td>			
                    <td width='30%' class='title'>보험기간</td>
                    <td width='22%' class='title'>해지사유발생일</td>
                    <td width='13%' class='title'>해지</td>						
                </tr>
            </table>
    	</td>
    </tr>    
<%	}else	if(gubun3.equals("8")){%>
<table border="0" cellspacing="0" cellpadding="0" width=1340>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='530' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='50' class='title'>연번</td>
                    <td width='70' class='title'>보험종류</td>
                    <td width='70' class='title'>보험상태</td>
                    <td width='90' class='title'>차량번호</td>
                    <td width='130' class='title'>차대번호</td>
                    <td width='120' class='title'>차명</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='840'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='100' class='title'>보험회사</td>
                    <td width='60' class='title'>용도</td>			
                    <td width='150' class='title'>증권번호</td>			
                    <td width='150' class='title'>보험기간</td>
                    <td width='80' class='title'>가입일자</td>					
                    <td width='80' class='title'>해지일자</td>					
                    <td width='200' class='title'>기타</td>			
                </tr>
            </table>
	    </td>
    </tr>
<%	}%>

<%	if(ins_size > 0){%>
<%		if(gubun3.equals("") || gubun3.equals("1") || gubun3.equals("2")){%>
    <tr>
	    <td class='line' width='400' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='50' align='center'><a name="<%=i+1%>"><%=i+1%></a><!--&nbsp;<%if(ins.get("USE_YN").equals("N")){%><span title='명의이전일:<%=AddUtil.ChangeDate2(String.valueOf(ins.get("MIGR_DT")))%>'>(매각)</span><%}%>--></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='70' align='center'><%=ins.get("INS_KD")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='70' align='center'><%=ins.get("INS_STS")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='90' align='center'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='120' align='center'><span title='<%=ins.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 9)%></span></td>
                </tr>
              <%		}%>
            </table>
	    </td>
	    <td class='line' width='930'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='100' align='center'><%=ins.get("INS_COM_NM")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='60' align="center"><%=ins.get("CAR_USE")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='150' align="center"><%=ins.get("INS_CON_NO")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='160' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='80' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_RENT_DT")))%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='80' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("EXP_DT")))%></td>					
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='120' align="center"><%=ins.get("AGE_SCP")%></td>					
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='60' align='center'><%=ins.get("AIR")%>개</td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='60' align='center'><a href="javascript:parent.insReg('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gs.gif"  align="absmiddle" border="0"></a></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='60' align='center'>
					  <%if(String.valueOf(ins.get("EXP_DT")).equals("")){%>
					  <a href="javascript:parent.insCls('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_hj.gif"  align="absmiddle" border="0"></a>					  
					  <%}%>
					</td>
                </tr>
              <%		}%>
            </table>
	    </td>
    </tr>
<%		}else if(gubun3.equals("4")){%>
    <tr>
	    <td class='line' width='35%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='16%' align='center' style='height:34'><a name="<%=i+1%>"><%=i+1%></a>&nbsp;<%if(ins.get("USE_YN").equals("N")){%><span title='명의이전일:<%=AddUtil.ChangeDate2(String.valueOf(ins.get("MIGR_DT")))%>'>(매각)</span><%}%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='15%' align='center'><%=ins.get("INS_KD")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='15%' align='center'><%=ins.get("INS_STS")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='20%' align='center'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='34%' align='center'><span title='<%=ins.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 9)%></span></td>
                </tr>
              <%		}%>
            </table>
	    </td>
	    <td class='line' width='65%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='12%' align='center' style='height:34'><%=ins.get("INS_COM_NM")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='8%' align="center"><%=ins.get("CAR_USE")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='23%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='12%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("CH_DT")))%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='14%' align='center'>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("1")){%>대물<%}%>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("2")){%>자기신체사고<%}%>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("3")){%>무보험차상해<%}%>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("4")){%>자기차량손해<%}%>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("5")){%>운전자연령<%}%>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("6")){%>애니카<%}%>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("7")){%>대물+자기신체<%}%>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("8")){%>차종변경<%}%>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("9")){%>자기차량손해<%}%>
        			  <%if(String.valueOf(ins.get("CH_ITEM")).equals("10")){%>대인Ⅱ<%}%>			
        			</td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='15%' align='center'><%=ins.get("CH_BEFORE")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='16%' align='center'><%=ins.get("CH_AFTER")%></td>						
                </tr>
              <%		}%>
            </table>
	    </td>
    </tr>
<%		}else if(gubun3.equals("3") || gubun3.equals("7")){%>
    <tr>
    	<td class='line' width='50%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='16%' align='center'><a name="<%=i+1%>"><%=i+1%></a>&nbsp;<%if(ins.get("USE_YN").equals("N")){%><span title='명의이전일:<%=AddUtil.ChangeDate2(String.valueOf(ins.get("MIGR_DT")))%>'>(매각)</span><%}%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='15%' align='center'><%=ins.get("EXP_ST")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='15%' align='center'><%=ins.get("EXP_AIM")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='20%' align='center'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='34%' align='center'><span title='<%=ins.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 9)%></span></td>
                </tr>
              <%		}%>
            </table>
    	</td>
    	<td class='line' width='50%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='17%' align='center'><%=ins.get("INS_COM_NM")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='13%' align="center"><%=ins.get("CAR_USE")%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='30%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='21%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("EXP_DT")))%></td>
                    <td <%if(ins.get("INS_STS").equals("만료")){%>class='is'<%}%> width='19%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("REQ_DT")))%></td>				
                </tr>
              <%		}%>
            </table>
    	</td>
    </tr>  
<%		}else if(gubun3.equals("5")){%>
    <tr>
	    <td class='line' width='55%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td width='16%' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
                    <td width='15%' align='center'><%=ins.get("CAU")%></td>
                    <td width='20%%' align='center'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                    <td width='27%' align='center'><%=ins.get("CAR_NUM")%></td>			
                    <td width='22%' align='center'><span title='<%=ins.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 9)%></span></td>
                </tr>
              <%		}%>
            </table>
	    </td>
	    <td class='line' width='45%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td width='25%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("DT")))%></td>
                    <td width='60%'>&nbsp;<span title='<%=ins.get("CONT")%>'><%=Util.subData(String.valueOf(ins.get("CONT")), 23)%></span></td>
                    <td width='15%' align="center"><a href="javascript:parent.insReg('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '')" onMouseOver="window.status=''; return true">
        			  <%if(String.valueOf(ins.get("CAU")).equals("갱신")){%><img src="/acar/images/center/button_in_gs.gif"  align="absmiddle" border="0"><%}else{%><img src="/acar/images/center/button_in_gi.gif"  align="absmiddle" border="0"><%}%>			
        			</a></td>				
                </tr>
              <%		}%>
            </table>
	    </td>
    </tr>    
<%		}else if(gubun3.equals("6")){%>
    <tr>
    	<td class='line' width='50%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    									Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td width='10%' align='center'><input type="checkbox" name="pr" value="<%=ins.get("CAR_MNG_ID")%>" ></td> 
                    <td width='15%' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
                    <td width='15%' align='center'>
        			  <%if(!String.valueOf(ins.get("MIGR_DT")).equals("")){%>매각<%}else{%>용도변경<%}%>		  
        			</td>
                    <td width='20%' align='center'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                    <td width='40%' align='center'><span title='<%=ins.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 9)%></span></td>
                </tr>
              <%		}%>
            </table>
    	</td>
    	<td class='line' width='50%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td width='20%' align='center'><%=ins.get("INS_COM_NM")%></td>
                    <td width='15%' align="center"><%=ins.get("CAR_USE")%></td>
                    <td width='30%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
                    <td width='22%' align="center">
        			  <%if(String.valueOf(ins.get("CAR_ST")).equals("1") && String.valueOf(ins.get("CAR_USE")).equals("업무용")){%><%=AddUtil.ChangeDate2(String.valueOf(ins.get("CHA_DT")))%>
        			  <%}else if(String.valueOf(ins.get("CAR_ST")).equals("2") && String.valueOf(ins.get("CAR_USE")).equals("영업용")){%><%=AddUtil.ChangeDate2(String.valueOf(ins.get("CHA_DT")))%>
        			  <%}else if(!String.valueOf(ins.get("MIGR_DT")).equals("")){%><%=AddUtil.ChangeDate2(String.valueOf(ins.get("MIGR_DT")))%><%}%>			
        			</td>
                    <td width='13%' align='center'><a href="javascript:parent.insCls('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_hj.gif"  align="absmiddle" border="0"></a></td>						
                </tr>
              <%		}%>
            </table>
    	</td>
    </tr>      
<%		}else if(gubun3.equals("8")){%>
    <tr>
	    <td class='line' width='530' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td width='50' align='center'><%=i+1%></td>
                    <td width='70' align='center'><%=ins.get("INS_KD")%></td>
                    <td  width='70' align='center'><%=ins.get("INS_STS")%></td>
                    <td  width='90' align='center'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                    <td  width='130' align='center'><%=ins.get("CAR_NUM")%></td>
                    <td  width='120' align='center'><%=ins.get("CAR_NM")%></td>
                </tr>
              <%		}%>
            </table>
	    </td>
	    <td class='line' width='840'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td width='100' align='center'><%=ins.get("INS_COM_NM")%></td>
                    <td width='60' align="center"><%=ins.get("CAR_USE")%></td>
                    <td width='150' align="center"><%=ins.get("INS_CON_NO")%></td>
                    <td width='150' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
                    <td width='80' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_RENT_DT")))%></td>
                    <td width='80' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("EXP_DT")))%></td>					
                    <td width='200' align='center'><%=ins.get("CONT")%></td>
					</td>
                </tr>
              <%		}%>
            </table>
	    </td>
    </tr>
<%		}%>  
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
