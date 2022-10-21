<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*, acar.sian.*"%>
<jsp:useBean id="ts_db" scope="page" class="acar.sian.TestClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
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
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String r_cls	 	= request.getParameter("r_cls")==null?"0":request.getParameter("r_cls");
	String s_cls_st	 	= request.getParameter("s_cls_st")==null?"0":request.getParameter("s_cls_st");
	String s_kd		 	= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd		 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String t_st_dt	 	= request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");	
	String t_end_dt	 	= request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");	
	Vector closes 		= ts_db.getClsList(r_cls, s_cls_st, s_kd, t_wd, t_st_dt, t_end_dt);
	int close_size 		= closes.size();
%>
<body onLoad="javascript:init()">
<form name='form1' method='post'>
<input type='hidden' name='close_size' value='<%=close_size%>'>
<%	if(r_cls.equals("0")){//해약리스트	%>
<table border="0" cellspacing="0" cellpadding="0" width='982'>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td id='td_title' width='372' class='line' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='372'>
				<tr>
					<td width='22' class='title'><font size='1'>해약<br/>구분</font></td>
					<td width='65' class='title'>해약일</td>
					<td width='95' class='title'>계약번호</td>
					<td width='120' class='title'>상호</td>
					<td width='70' class='title'>계약자</td>
				</tr>
			</table>
		</td>
		<td width='610' class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='610'>
				<tr>
					<td width='65' class='title'>계약일</td>
					<td width='65' class='title'>대여개시일</td>
					<td width='100' class='title'>차명</td>
					<td width='100' class='title'>차량번호	</td>
					<td width='65' class='title'>등록일</td>
					<td width='55' class='title'>대여방식</td>
					<td width='55' class='title'>대여기간</td>
					<td width='55' class='title'>영업담당</td>
					<td width='30' class='title'><font size='1'>영업소<br/>코드</font></td>
					<td width='20' class='title'><font size='1'>처리<br/>구분</font></td>
				</tr>
			</table>
		</td>
	</tr>
<%	}else{//미해약 리스트 	%>
<table border="0" cellspacing="0" cellpadding="0" width='940'>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td id='td_title' width='365' class='line' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='365'>
				<tr>
					<td width='95' class='title'>계약번호</td>
					<td width='120' class='title'>상호</td>
					<td width='80' class='title'>계약자</td>
					<td width='70' class='title'>계약일</td>
				</tr>
			</table>
		</td>
		<td width='575' class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='575'>
				<tr>
					<td width='70' class='title'>대여개시일</td>
					<td width='100' class='title'>차명</td>
					<td width='100' class='title'>차량번호</td>
					<td width='70' class='title'>등록일</td>
					<td width='50' class='title'>대여방식</td>
					<td width='50' class='title'>대여기간</td>
					<td width='50' class='title'>영업담당</td>
					<td width='55' class='title'><font size='1'>영업소코드</font></td>
<%		if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){	//권한 있으면 등록 라디오 버튼 출력%>								
					<td width='30' class='title'>등록</td>
<%		}else{	%>
					<td width='30' class='title'>&nbsp;</td>
<%		}		%>
				</tr>
			</table>
		</td>
	</tr>
<%	}
	
	if(close_size > 0){
		if(r_cls.equals("0")){//해약리스트	%>
	<tr>
		<td class='line' width='372' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=372>
<%			for(int i = 0 ; i < close_size ; i++){
				Hashtable close = (Hashtable)closes.elementAt(i);	%>
				<tr>
					<td width='22' align='center'><%=close.get("CLS_ST")%></td>
					<td width='65' align='center'><%=close.get("CLS_DT")%></td>
					<td width='95' align='center'><a href="javascript:parent.view_cls('<%=close.get("RENT_MNG_ID")%>', '<%=close.get("RENT_L_CD")%>', '<%=close.get("CLS_ST")%>')" onMouseOver="window.status=''; return true"><%=close.get("RENT_L_CD")%></a></td>
					<td width='120' align='center'><a href="javascript:parent.view_client('<%=close.get("RENT_MNG_ID")%>', '<%=close.get("RENT_L_CD")%>', '<%=close.get("RENT_ST")%>', '<%=close.get("CLS_ST")%>')" onMouseOver="window.status=''; return true"><span title='<%=close.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(close.get("FIRM_NM")), 7)%></span></a>
					<td width='70' align='center'><span title="<%=close.get("CLIENT_NM")%>"><%=Util.subData(String.valueOf(close.get("CLIENT_NM")), 3)%></span></td>
				</tr>
<%			}		%>
			</table>
		</td>
		<td class='line' width='610'>
			<table border="0" cellspacing="1" cellpadding="0" width=610>

<%			for(int i = 0 ; i < close_size ; i++){
				Hashtable close = (Hashtable)closes.elementAt(i);	%>
				<tr>
					<td width='65' align='center'><%=close.get("RENT_DT")%></td>
					<td width='65' align='center'><%=close.get("RENT_START_DT")%></td>
					<td width='100' align='center'><span title='<%=close.get("CAR_NM")%>'><%=Util.subData(String.valueOf(close.get("CAR_NM")), 7)%></span></td>
					<td width='100' align='center'><span title='<%=close.get("CAR_NO")%>'><%=close.get("CAR_NO")%></span></td>
					<td width='65' align='center'><%=close.get("INIT_REG_DT")%></td>
					<td width='55' align='center'><%=close.get("RENT_WAY")%></td>
					<td width='55' align='center'><%=close.get("CON_MON")%>개월</td>
					<td width='55' align='center'><%=close.get("USER_NM")%></td>
					<td width='30' align='center'><%=close.get("BRCH_ID")%></td>
<%				if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){	//쓰기권한으로만  - 미처리된것 처리	%>									
					<td width='20' align='center'>
						<%if(close.get("TERM_YN").equals("N")){%>
							<a href="javascript:parent.close_cont('<%=close.get("RENT_MNG_ID")%>', '<%=close.get("RENT_L_CD")%>', '<%=close.get("CLS_ST")%>')" onMouseOver="window.status=''; return true">N</a>
						<%}else{%><%=close.get("TERM_YN")%><%}%>
					</td>
<%				}else{	%>
					<td width='20' align='center'><%=close.get("TERM_YN")%></td>
<%				}		%>
				</tr>
<%			}	%>
			</table>
		</td>
	</tr>		
<%		}else{	//미해얄리스트	%>
	<tr>
		<td class='line' width='365' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='365'>
<%			for(int i = 0 ; i < close_size ; i++){
				Hashtable close = (Hashtable)closes.elementAt(i);	%>
				<tr>
					<td width='95'  align='center'><%=close.get("RENT_L_CD")%></td>
					<td width='120' align='center'><a href="javascript:parent.view_client('<%=close.get("RENT_MNG_ID")%>', '<%=close.get("RENT_L_CD")%>', '<%=close.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><span title='<%=close.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(close.get("FIRM_NM")), 7)%></span></a>
					<td width='80'  align='center'><span title="<%=close.get("CLIENT_NM")%>"><%=Util.subData(String.valueOf(close.get("CLIENT_NM")), 3)%></span></td>
					<td width='70'  align='center'><%=close.get("RENT_DT")%></td>
				</tr>
<%			}	%>
			</table>
		</td>
		<td class='line' width='575'>
			<table border="0" cellspacing="1" cellpadding="0" width='575'>
<%			for(int i = 0 ; i < close_size ; i++){
				Hashtable close = (Hashtable)closes.elementAt(i);	%>
				<tr>
					<td width='70' align='center'><%=close.get("RENT_START_DT")%></td>
					<td width='100' align='center'><span title='<%=close.get("CAR_NM")%>'><%=Util.subData(String.valueOf(close.get("CAR_NM")), 7)%></span></td>
					<td width='100' align='center'><span title='<%=close.get("CAR_NO")%>'><%=close.get("CAR_NO")%></span></td>
					<td width='70' align='center'><%=close.get("INIT_REG_DT")%></td>
					<td width='50' align='center'><%=close.get("RENT_WAY")%></td>
					<td width='50' align='center'><%=close.get("CON_MON")%>개월</td>
					<td width='50' align='center'><%=close.get("USER_NM")%></td>
					<td width='55' align='center'><%=close.get("BRCH_ID")%></td>
<%				if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){	//쓰기권한으로만  - 등록	%>						
					<td width='30' align='center'><input type='radio' name='c_cls_reg' value='<%=close.get("RENT_MNG_ID")+""+close.get("RENT_L_CD")%>'></td>
<%				}	%>
				</tr>
<%			}		%>
			</table>
		</td>
	</tr>
<%		}
	}else{
		if(r_cls.equals("0")){	%>
	<tr>
		<td class='line' width='372' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=372>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='610'>
			<table border="0" cellspacing="1" cellpadding="0" width=610>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%		}else{	%>
	<tr>
		<td class='line' width='365' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=365>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='575'>
			<table border="0" cellspacing="1" cellpadding="0" width=575>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%		}
	}		%>
</table>
</form>
</body>
</html>