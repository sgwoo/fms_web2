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
	
	
	
	Vector vt = af_db.getFeeScdStopList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
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
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()" rightmargin=0>
<form name='form1' action='fee_scd_sc.jsp' method="post">
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1400>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='25%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        			<td width='11%' class='title'>연번</td>
        			<td width='20%' class='title'>구분</td>		
        			<td width='31%' class='title'>계약번호</td>
        			<td width='38%' class='title'>상호</td>
    		    </tr>
    		</table>
	    </td>
	    <td class='line' width='75%'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
    		    <tr>
        			<td width='9%' class='title'>차량번호</td>
        			<td width='6%' class='title'>연체횟수</td>
        			<!--<td width='10%' class='title'>최종발행일자</td>			-->
        			<td width='10%' class='title'>만료예정일자</td>
        			<td width='28%' class='title'>중지사유</td>					
        			<td width='10%' class='title'>중지시작일</td>
        			<td width='10%' class='title'>중지종료일</td>					
        			<td width='10%' class='title'>중지해제일</td>
        			<td width='7%' class='title'>등록자</td>
        			<td width='10%' class='title'>등록일자</td>										
    		    </tr>
    		</table>
	    </td>
	</tr>
	<tr>
	    <td class='line' width='25%' id='td_con' style='position:relative;'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%	if(vt_size > 0){%>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
    		    <tr>
    			    <td  align='center' width='11%'><%=i+1%></td>
    			    <td  align='center' width='20%'><%=ht.get("STOP_ST_NM")%></td>	
    			    <td  align='center' width='31%'><a href="javascript:parent.view_scd_fee_stop('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>								
    			    <td  align='center' width='38%'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
    		    </tr>					
<%		} %>					
<%	}else{ %>				
		        <tr>
			        <td colspan="4" align='center'>등록된 데이타가 없습니다</td>
		        </tr>						
<%	}%>					
		    </table>
	    </td>
	    <td class='line' width='75%'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%	if(vt_size > 0){%>			
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
		        <tr>
        			<td  align='center' width='9%'><a href="javascript:parent.view_scd_fee('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_NO")%></a></td>					
        			<td  align='center' width='6%'><%=ht.get("CNT")%></td>		  
        			<!--<td  align='center' width="10%"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>-->
        			<td  align='center' width='10%'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
        			<td  align='center' width="28%"><span title='<%=ht.get("STOP_CAU")%>'><%=Util.subData(String.valueOf(ht.get("STOP_CAU")), 12)%></span></td>
        			<td  align='center' width='10%'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("STOP_S_DT")))%></td>
        			<td  align='center' width='10%'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("STOP_E_DT")))%></td>					
        			<td  align='center' width="10%"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CANCEL_DT")))%></td>
        			<td  align='center' width="7%"><%=ht.get("REG_NM")%></td>
        			<td  align='center' width="10%"><%=ht.get("REG_DT")%></td>
		        </tr>
<%		}%>
<%	}else{ %>	
		        <tr>
			        <td colspan="10" align='center'></td>
		        </tr>						
<%	}%>								
		    </table>
 	    </td>
	</tr>		
</table>
</form>
</body>
</html>
