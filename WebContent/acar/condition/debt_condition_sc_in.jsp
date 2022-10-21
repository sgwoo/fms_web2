<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	
	Vector stats = new Vector();
	if(s_kd.equals("2"))	stats = d_db.getDebtStatics(s_kd, s_bank);
	else					stats = d_db.getDebtStatics(s_kd, t_wd);
	int stat_size = stats.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
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
	
-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding='0' width='1410'>
<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td id='td_title' class=line style='position:relative;' width='32%'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
				<tr>
					<td class='title' colspan='5'>차량사항</td>
				</tr>
				<tr>
				    <td width=10% class=title>연번</td>	
					<td class=title width='22%'>계약번호</td>
            		<td class=title width='26%'>상호</td>
            		<td class=title width='25%'>차종</td>
            		<td class=title width='17%' >출고일</td>
				</tr>				
			</table>
		</td>
		<td class=line width='68%'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
				<tr>
					<td class='title' colspan='4'>매입사항</td>
					<td class='title' colspan='4'>대출사항</td>
					<td class='title' colspan='4'>할부사항</td>
				</tr>
				<tr>
					<td class=title width='9%'>차량가격</td>
            		<td class=title width='8%'>탁송료</td>
            		<td class=title width='9%'>에누리</td>
            		<td class=title width='9%'>매입가</td>
            		<td class=title width='8%'>대출사명</td>
            		<td class=title width='8%'>상환방법</td>
            		<td class=title width='8%'>대출이율</td>
            		<td class=title width='8%'>이자합계</td>
            		<td class=title width='8%'>선납금</td>
            		<td class=title width='9%'>할부원금</td>
            		<td class=title width='8%'>할부수수료</td>
            		<td class=title width='8%'>인지대</td>
				</tr>				
			</table>
		</td>
	</tr>
<%
	if(stat_size > 0)
	{
%>            	
	<tr>
		<td id='td_con' class=line style='position:relative;' width='32%'>
           	<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>           		
           		<tr>
           			<td align="center" width=10%><%= i+1%></td>
					<td width='22%'  align='center'><%=stat.get("RENT_L_CD")%></td>
			    	<td width='26%' align='center'><span title='<%=stat.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(stat.get("FIRM_NM")), 8)%></span></td>
			    	<td width='25%' align='center'><span title='<%=stat.get("CAR_NM_BR")%>'><%=Util.subData(String.valueOf(stat.get("CAR_NM")), 8)%></span></td>
			    	<td width='17%'  align='center'><%=stat.get("DLV_DT")%></td>
           		</tr>
<%
		}
%>
           	</table>
		</td>
        <td class=line width='68%'>
           	<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>            	
           		<tr>
           			<td width='9%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("CAR_AMT")))%>원&nbsp;</td>
			    	<td width='8%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("SD_AMT")))%>원&nbsp;</td>
			    	<td width='9%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("DC_AMT")))%>원&nbsp;</td>
			    	<td width='9%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("TOT_AMT")))%>원&nbsp;</td>
			    	<td width='8%' align='center'><span title='<%=stat.get("CPT_NM")%>'><%=Util.subData(String.valueOf(stat.get("CPT_NM")), 5)%></span></td>
			    	<td width='8%' align='center'><%=stat.get("RTN_WAY")%></td>
			    	<td width='8%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("LEND_INT")))%>원&nbsp;</td>
			    	<td width='8%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("LEND_INT_AMT")))%>원&nbsp;</td>
			    	<td width='8%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("PP_AMT")))%>원&nbsp;</td>
			    	<td width='9%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("LEND_PRN")))%>원&nbsp;</td>
			    	<td width='8%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("ALT_FEE")))%>원&nbsp;</td>
			    	<td width='8%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("STP_FEE")))%>원&nbsp;</td>
           		</tr>
<%
		}
%>
           	</table>
		</td>
	</tr>
<%
	}else{
%>
	<tr>
		<td class='line' id='td_con' width='32%' style='position:relative;' >
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td width='68%' class='line'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>		
	</tr>
<%
	}
%>
</table>
</body>
</html>