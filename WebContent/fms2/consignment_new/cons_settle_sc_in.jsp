<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = cs_db.getConsignmentSettleList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
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
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='1530'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='30%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				    <td width='10%' class='title'>연번</td>
		            <td width='25%' class='title'>탁송번호</td>
				    <td width='30%' class='title'>탁송업체</td>
		            <td width="10%" class='title'>구분</td>
		            <td width="25%" class='title'>차량번호</td>				  
				</tr>
			</table>
		</td>
		<td class='line' width='70%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
		            <td width="10%" class='title'>차명</td>					
        		    <td width='10%' class='title'>탁송사유</td>
				    <td width='11%' class='title'>출발지</td>
				    <td width='11%' class='title'>도착지</td>				  
				    <td width='6%' class='title'>운전자</td>				  				  
				    <td width='15%' class='title'>출발요청일시</td>										
				    <td width='15%' class='title'>출발예정일시</td>										
				    <td width='7%' class='title'>의뢰자</td>					
					<td width='7%' class='title'>관리담당자</td>
				    <td width='10%' class='title'>수신자</td>					
			    </tr>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line' width='31%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			String prev_car_no = String.valueOf(ht.get("CAR_NO"));
			String seq = String.valueOf(ht.get("SEQ"));
			String car_no = "";
			if( prev_car_no.length() > 10 ) {
				car_no = cs_db.getCarNo(String.valueOf(ht.get("CONS_NO")), Integer.parseInt(seq));
			}
			car_no = car_no == "" ? Util.subData(prev_car_no, 8) : car_no;
			%>
				<tr>
					<td  width='10%' align='center'><%=i+1%></td>
					<td  width='25%' align='center'><a href="javascript:parent.view_cons('<%=ht.get("CONS_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CONS_NO")%>-<%=ht.get("SEQ")%></a></td>					
					<td  width='30%' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 10)%></span></td>
					<td  width='10%' align='center'><%=ht.get("CONS_ST_NM")%></td>					
					<td  width='25%' align='center'><%=car_no%></td>
				</tr>
<%		}%>
			</table>
		</td>
		<td class='line' width='69%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>					
					<td  width='10%' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>															
					<td  width='10%' align='center'><span title='<%=ht.get("CONS_CAU_NM")%>'><%=Util.subData(String.valueOf(ht.get("CONS_CAU_NM")), 8)%></span></td>
					<td  width='11%' align='center'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 6)%></span></td>
					<td  width='11%' align='center'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 6)%></span></td>
					<td  width='6%' align='center'><span title='<%=ht.get("DRIVER_NM")%>'><%=Util.subData(String.valueOf(ht.get("DRIVER_NM")), 3)%></span></td>
					<td  width='15%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_REQ_DT")))%></td>					
					<td  width='15%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_EST_DT")))%></td>					
					<td  width='7%' align='center'><%=ht.get("USER_NM1")%></td>										
					<td  width='7%' align='center'><%=ht.get("MNG_NM")%></td>
					<td  width='10%' align='center'><span title='<%=ht.get("USER_NM2")%>'><%=Util.subData(String.valueOf(ht.get("USER_NM2")), 5)%></span></td>										
				</tr>
<%		}%>
			</table>
		</td>
<%	}else{%>                     
	<tr>
		<td class='line' width='31%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='69%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
