<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	String idx 		= request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	Vector vt = af_db.getFeeScdListRmAll(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int vt_size = vt.size();
%>

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
	
		//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		 
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}	
			}
		}
		return;
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()" rightmargin=0>
<form name='form1' action='fee_scd_rm_sc.jsp' method="post">
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1450>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='370' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td class='title' width="30"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
        			<td width='30' class='title'>연번</td>
        			<td width='60' class='title'>구분</td>		
        			<td width='100' class='title'>계약번호</td>
        			<td width='150' class='title'>상호</td>
    		    </tr>
    		</table>
	    </td>
	    <td class='line' width='1080'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
    		    <tr>
        			<td width='100' class='title'>차량번호</td>
        			<td width='110' class='title'>차명</td>
        			<td width='70' class='title'>계약구분</td>			
        			<td width='80' class='title'>계약일자</td>
        			<td width='80' class='title'>대여개시일</td>
        			<td width='80' class='title'>대여만료일</td>					
        			<td width='80' class='title'>최종사용일</td>										
					<td width='80' class='title'>스케쥴생성</td>
        			<td width='70' class='title'>대여개월</td>					
        			<td width='70' class='title'>등록여부</td>
        			<td width='70' class='title'>진행상태</td>			
        			<td width='70' class='title'>비고</td>								
        			<td width='70' class='title'>경과월수</td>													
        			<td width='50' class='title'>알림</td>
    		    </tr>
    		</table>
	    </td>
	</tr>
	<tr>
	    <td class='line' width='370' id='td_con' style='position:relative;'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%	if(vt_size > 0){%>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			String use_yn = String.valueOf(ht.get("USE_YN"));
			String end_yn = String.valueOf(ht.get("END_YN"));%>
    		    <tr>
					<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='30'><input type="checkbox" name="ch_l_cd" value="<%=ht.get("RENT_MNG_ID")%><%=ht.get("RENT_L_CD")%><%=ht.get("CAR_MNG_ID")%>"></td>
    			    <td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='30'><%=i+1%></td>
    			    <td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='60'><%=ht.get("GUBUN")%></td>	
    			    <td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='100'><a href="javascript:parent.view_scd_fee('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_ST")%>', '<%=ht.get("REG_YN")%>','<%=ht.get("GUBUN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>								
    			    <td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='150'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></span></td>
    		    </tr>					
<%		} %>					
<%	}else{ %>				
		        <tr>
			        <td colspan="5" align='center'>등록된 데이타가 없습니다</td>
		        </tr>						
<%	}%>					
		    </table>
	    </td>
	    <td class='line' width='1080'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%	if(vt_size > 0){%>			
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			String end_yn = String.valueOf(ht.get("END_YN"));%>
		        <tr>
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='100'><span title='최초등록일:<%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%>'><%=ht.get("CAR_NO")%></span></td>					
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='110'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 5)%></span></td>		  
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width="70"><span title='계약일:<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>'>
        				<%	if(String.valueOf(ht.get("CONT_ST")).equals("1")) out.println("신규");
        					else if(String.valueOf(ht.get("CONT_ST")).equals("3")) out.println("대차");
        					else if(String.valueOf(ht.get("CONT_ST")).equals("4")) out.println("증차");
        					else if(String.valueOf(ht.get("CONT_ST")).equals("5")) out.println("연장");
        					else if(String.valueOf(ht.get("CONT_ST")).equals("2")) out.println("연장");
        					else if(String.valueOf(ht.get("CONT_ST")).equals("6"))  out.println("재리스");
        					else if(String.valueOf(ht.get("CONT_ST")).equals("7"))  out.println("재리스");%>
							<%=ht.get("CAR_GU_NM")%>
							</span>
        			</td>
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='80'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='80'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='80'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='80'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>										
					<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='80'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("CNG_DT")))%></td>										
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='70'><%=ht.get("CON_MON")%>개월<%=ht.get("CON_DAY")%>일</td>					
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width="70"><%=ht.get("REG_YN")%></td>
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width="70"><%=ht.get("END_YN")%></td>												
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width="70">
					<%if(String.valueOf(ht.get("REG_YN")).equals("미등록") && String.valueOf(ht.get("START_YN")).equals("신차개시")){%>
					<font color=red><%=ht.get("START_YN")%></font>
					<%}else if(String.valueOf(ht.get("REG_YN")).equals("미등록") && String.valueOf(ht.get("START_YN")).equals("차량등록") && !String.valueOf(ht.get("CAR_GU_NM")).equals("(재)")){%>
					<a href="javascript:parent.req_fee_start_act('신차개시요청', '<%=ht.get("RENT_L_CD")%> <%=ht.get("FIRM_NM")%> <%=ht.get("CAR_NO")%> <%=ht.get("GUBUN")%><%=ht.get("CAR_GU_NM")%> : 신차대여개시 처리해주십시오.', '<%=ht.get("BUS_ID")%>')" onMouseOver="window.status=''; return true" title='최초영업자에게 <%=ht.get("INIT_REG_DT")%>등록차량 신차개시 처리 요청하기'><font color=green><%=ht.get("START_YN")%></font></a>
					<%}else{%>
					<%=ht.get("START_YN")%>
					<%}%>
					</td>					
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width='70'>
					<%if(String.valueOf(ht.get("REG_YN")).equals("미등록") && String.valueOf(ht.get("GUBUN")).equals("지연") && !String.valueOf(ht.get("USE_MON")).equals("0")){%>
					<font color=red><%=ht.get("USE_MON")%>개월</font>
					<%}else{%>
					<%=ht.get("USE_MON")%>개월
					<%}%>
					</td>		
        			<td <%if(end_yn.equals("종료"))%>class=is<%%> align='center' width="50"><a href="javascript:parent.req_fee_start_act('', '<%=ht.get("RENT_L_CD")%> <%=ht.get("FIRM_NM")%> <%=ht.get("CAR_NO")%> <%=ht.get("GUBUN")%><%=ht.get("CAR_GU_NM")%>', '<%=ht.get("BUS_ID")%>')" onMouseOver="window.status=''; return true" title='최초영업자(계약담당)에게 알림'>알림</a></td>																																					
		        </tr>
<%		}%>
<%	}else{ %>	
		        <tr>
			        <td colspan="12" align='center'></td>
		        </tr>						
<%	}%>								
		    </table>
 	    </td>
	</tr>		
</table>
</form>
</body>
</html>