<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.tint.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
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
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = t_db.getTintNonPayList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6	= 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
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
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/tint/tint_n_frame.jsp'>
  <input type='hidden' name='tint_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='1290'>
  <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='420' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='50' class='title' style='height:51'>연번</td>
		          <td width='100' class='title'>청구일자</td>
				  <td width='120' class='title'>용품업체</td>
		          <td width="100" class='title'>지점</td>
		          <td width="50" class='title'>건수</td>				  
				</tr>
			</table>
		</td>
		<td class='line' width='870'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td colspan="2" class='title'>결재</td>				  				  
				  <td width='80' rowspan="2" class='title'>지출</td>
				  <td width='150' rowspan="2" class='title'>기간</td>				  
				  <td colspan="6" class='title'>청구금액</td>				  				  
				  <!--
				  <td width='6%' rowspan="2" class='title'>아마존카</td>
				  <td colspan="2" class='title'>영업사원</td>
				  <td colspan="2" class='title'>고객</td>				  
				  -->
			    </tr>
				<tr>
				  <td width='80' class='title'>용품관리자</td>
			      <td width='80' class='title'>총무팀장</td>
			      <td width='80' class='title'>썬팅비</td>
			      <td width='80' class='title'>청소용품비</td>
			      <td width='80' class='title'>네비게이션</td>
			      <td width='80' class='title'>블랙박스</td>
			      <td width='80' class='title'>기타금액</td>
			      <td width='80' class='title'>합계</td>
			      <!--
			      <td width='6%' class='title'>세전가감</td>
			      <td width='6%' class='title'>세후가감</td>
			      <td width='6%' class='title'>현금지급</td>
			      <td width='6%' class='title'>대여료합산</td>				  				  				  				  				  
			      -->
			  </tr>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line' width='420' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
					<td  width='50' align='center'><%=i+1%></td>
					<td  width='100' align='center'><a href="javascript:parent.tint_doc_view('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '<%=ht.get("REQ_DT")%>', '<%=ht.get("BR_ID")%>', '', '<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></a></td>					
					<td  width='120' align='center'><%=ht.get("OFF_NM")%></td>
					<td  width='100' align='center'><%=ht.get("BR_NM")%></td>					
					<td  width='50' align='center'><%=ht.get("CNT")%>건</td>										
				</tr>
<%		}%>
				<tr>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>				  
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				</tr>
			</table>
		</td>
		<td class='line' width='870'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>											
					<td  width='80' align='center'><%=ht.get("USER_NM1")%></td>
					<td  width='80' align='center'><%=ht.get("USER_NM2")%></td>
					<td  width='80' align='center'>
					  <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%>
					   <a href="javascript:parent.tint_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '<%=ht.get("REQ_DT")%>', '<%=ht.get("BR_ID")%>', '', '<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_cr.gif" align="absbottom" border="0"></a> 
					  <%}else{%>-<%}%>
					</td>					
					<td  width='150' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIN_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("MAX_DT")))%></td>					
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TINT_AMT")))%></td>					
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CLEANER_AMT")))%></td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("NAVI_AMT")))%></td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("BLACKBOX_AMT")))%></td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
					<!--
					<td  width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_AMT")))%></td>
					<td  width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("E_SUB_AMT1")))%></td>
					<td  width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("E_SUB_AMT2")))%></td>					
					<td  width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("C_SUB_AMT1")))%></td>
					<td  width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("C_SUB_AMT2")))%></td>										
					-->
				</tr>
<%			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("TINT_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("CLEANER_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("NAVI_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("A_AMT")));
			total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("E_SUB_AMT1")));
			total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("E_SUB_AMT2")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("C_SUB_AMT1")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("C_SUB_AMT2")));
			total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("BLACKBOX_AMT")));
		}%>
				<tr>											
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>					
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>					
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt11)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
					<!--
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt6)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt7)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt8)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt9)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt10)%></td>
					-->
				</tr>
			</table>
		</td>
<%	}else{%>
	<tr>
		<td class='line' width='420' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='870'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
