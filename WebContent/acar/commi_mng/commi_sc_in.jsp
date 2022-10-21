<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.commi_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"11":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	
	Vector commis = ac_db.getCommiList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int commi_size = commis.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width='1760'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='28%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='12%' class='title'>연번</td>
					<td width='20%' class='title'>계약번호</td>
					<td width='25%' class='title'>상호</td>
					<td width='18%' class='title'>차량번호</td>
					<td width='25%' class='title'>차명</td>
				</tr>
			</table>
		</td>
		<td class='line' width='72%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>					
			        <td width='10%' class='title'>자동차회사</td>					
			        <td width='9%' class='title'>자동차영업소</td>					
			        <td width='6%' class='title'>영업사원</td>
			        <td width='6%' class='title'>실수령인</td>
			        <td width='9%' class='title'>주민번호</td>
			        <td width='15%' class='title'>주소</td>										
				<td width='8%' class='title'>출고일자</td>
				<td width='6%' class='title'>수당구분</td>
				<td width='8%' class='title'>지급수수료</td>					
				<td width='8%' class='title'>세금</td>										
				<td width='8%' class='title'>실지급액</td>															
				<td width='7%' class='title'>지급일자</td>
				</tr>
			</table>
		</td>
	</tr>
<%	if(commi_size > 0){%>
	<tr>
		<td class='line' width='28%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);%>
				<tr>
					<td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width=12%><%=i+1%><%if(commi.get("USE_YN").equals("N")) out.println("(해지)");%></td>
					<td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width=20%><a href="javascript:parent.view_commi('<%=commi.get("RENT_MNG_ID")%>', '<%=commi.get("RENT_L_CD")%>', '<%=commi.get("CAR_MNG_ID")%>', '<%=commi.get("EMP_ID")%>')" onMouseOver="window.status=''; return true"><%=commi.get("RENT_L_CD")%></a></td>
					<td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='left'   width=25%>&nbsp;<span title='<%=commi.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(commi.get("FIRM_NM")), 8)%></span></td>
					<td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width=18%><%=commi.get("CAR_NO")%></td>
					<td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width=25%><span title='<%=commi.get("CAR_NM")%> <%=commi.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(commi.get("CAR_NM"))+" "+String.valueOf(commi.get("CAR_NAME")), 9)%></span></td>
				</tr>		
        <%		}%>
				<tr>
		            <td class="title_p">&nbsp;</td>		  
            		<td class="title_p">&nbsp;</td>
            		<td class="title_p" align='center'>합계</td>					
            		<td class="title_p">&nbsp;</td>
            		<td class="title_p">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td class='line' width='72%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%		for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);%>
                <tr> 
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='10%'><span title='<%=commi.get("COM_NM")%>'><%=Util.subData(String.valueOf(commi.get("COM_NM")), 7)%></span></td>
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='9%'><span title='<%=commi.get("CAR_OFF_NM")%>'><%=Util.subData(String.valueOf(commi.get("CAR_OFF_NM")), 6)%></span></td>
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='6%'><span title='<%=commi.get("EMP_NM")%>'><%=Util.subData(String.valueOf(commi.get("EMP_NM")), 5)%></span></td>
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='6%'><span title='<%=commi.get("EMP_ACC_NM")%>'><%=Util.subData(String.valueOf(commi.get("EMP_ACC_NM")), 5)%></span></td>
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='9%'><%=AddUtil.ChangeEnp(String.valueOf(commi.get("REC_SSN")))%></td>
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='15%'><span title='<%=commi.get("REC_ADDR")%>'><%=Util.subData(String.valueOf(commi.get("REC_ADDR")), 15)%></span></td>		  		  
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='8%'><%=commi.get("DLV_DT")%></td>
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='6%'><%=commi.get("COMMI_ST")%></td>		  
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='right' width='8%'><%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></td>
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='right' width='8%'><%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></td>
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='right' width='8%'><%=Util.parseDecimal(String.valueOf(commi.get("DIF_AMT")))%></td>
                    <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'  width='7%'><%=commi.get("SUP_DT")%></td>
                </tr>
                  <%		total_amt = total_amt  + Long.parseLong(String.valueOf(commi.get("COMMI")));
        					total_amt2 = total_amt2  + Long.parseLong(String.valueOf(commi.get("COMMI_FEE")));
        					total_amt3 = total_amt3  + Long.parseLong(String.valueOf(commi.get("DIF_AMT")));
        		}%>
                <tr> 
                    <td class="title_p">&nbsp;</td>
                    <td class="title_p">&nbsp;</td>
                    <td class="title_p">&nbsp;</td>
                    <td class="title_p">&nbsp;</td>
                    <td class="title_p">&nbsp;</td>
                    <td class="title_p">&nbsp;</td>
                    <td class="title_p">&nbsp;</td>
                    <td class="title_p">&nbsp;</td>		
        			<td class="title_p" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
        			<td class="title_p" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
        			<td class="title_p" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
                    <td class="title_p">&nbsp;</td>		
                </tr>
            </table>
		</td>
	</tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='28%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='72%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</body>
</html>
