<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String idx_gubun 	= request.getParameter("idx_gubun")==null?"":request.getParameter("idx_gubun");
	

	Vector stats = new Vector();
	
	stats = oc_db.getDlvStats_out(s_kd, t_wd, dt, t_st_dt, t_end_dt, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, save_dt);
	
	int stat_size = stats.size();
	
	long total_amt 	= 0;
	long total_amt2 	= 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table_t.css'>
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
<body>
<table border=0 cellspacing=0 cellpadding='0' width='800'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
		<td class=line >
			<table border=0 cellspacing=1 cellpadding=0 width='800'>
				<tr>
					<td class='title' width='50'>연번</td>
				<!--	<td class='title' width='80'>계출번호</td> -->
				<!--	<td class='title' width='120'>상호</td> -->
            		<td class='title' width='100'>차종</td>
            	<!--	<td class='title' width='80'>차량번호</td> -->
            		<td class='title' width='100'>출고일</td>
            		<td class='title' width='100'>등록일</td>
            		<td class='title' width='150'>출고지점</td>
            		<td class='title' width='100'>차대번호</td>
            		<td class='title' width='100'>영업효율</td>
    				<!--<td class='title' width='100'>영업효율_2</td>-->
				</tr>
			</table>
		</td>
	</tr>
<%
	if(stat_size > 0)
	{
%>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 cellpadding='0' width='800'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>            	
           		<tr>
           			<td align='center' width='50'><%=i+1%></td>
           		<!--	<td align='center' width='80'>&nbsp;<span title='<%=stat.get("RPT_NO")%>'><%=Util.subData(String.valueOf(stat.get("RPT_NO")), 5)%></span></td> -->
				<!--	<td align='center' width='120'>&nbsp;<span title='<%=stat.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(stat.get("FIRM_NM")), 5)%></span></td> -->
            		<td align='center' width='100'>&nbsp;<span title='<%=stat.get("CAR_NM")%>'><%=Util.subData(String.valueOf(stat.get("CAR_NM")), 6)%></span></td>
           		<!--	<td align='center' width='80'><%=stat.get("CAR_NO")%></td> -->
                    <td align='center' width='100'><%=stat.get("DLV_DT")%></td>
                    <td align='center' width='100'><%=stat.get("INIT_REG_DT")%></td>
                    <td align='center' width='150'>&nbsp;<%=stat.get("DLV_OFF")%></td>
                    <td align='center' width='100'><%=stat.get("CAR_NUM2")%></td>
            		<td align='right' width='100'><%=AddUtil.parseDecimal(String.valueOf(stat.get("BC_S_F")))%>&nbsp;</td>
    				<!--<td align='right' width='100'><%=AddUtil.parseDecimal(String.valueOf(stat.get("BC_S_F_2")))%>&nbsp;</td>-->
           		</tr>
<%
			total_amt 	= total_amt + AddUtil.parseInt(String.valueOf(stat.get("BC_S_F")));
			total_amt2 	= total_amt2 + AddUtil.parseInt(String.valueOf(stat.get("BC_S_F_2")));
		}
%>
           		<tr>
           			<td class="title" colspan="6">합계 </td>
           			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>&nbsp;</td>
    				<!--<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>&nbsp;</td>-->
           		</tr>
			</table>
		</td>
	</tr>
<%
	}
	else
	{
%>
	<tr>
		<td class=line >
			<table border=0 cellspacing=1 cellpadding='0' width='800'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
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