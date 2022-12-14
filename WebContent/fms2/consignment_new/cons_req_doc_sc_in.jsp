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
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = cs_db.getConsignmentReqDocList(s_kd, t_wd, gubun1, st_dt, end_dt);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;	//세차수수료(20190517)
	
	long total_amt11 = 0;	//외부탁송(2022-07)
	long total_amt12 = 0;	//대행2022-07)
	long total_amt13 = 0;	//(2022-07)
	
	String admin_yn = "";
	if(nm_db.getWorkAuthUser("전산팀",user_id)){
		admin_yn = "Y";
	}
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
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/consignment_new/cons_req_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='1850'>
  <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='30%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='10%' class='title' style='height:80'>연번</td>
		          <td width='25%' class='title'>청구일자</td>
				  <td width='30%' class='title'>탁송업체</td>
		          <td width="20%" class='title'>지점</td>
		          <td width="15%" class='title'>건수</td>				  
				</tr>
			</table>
		</td>
		<td class='line' width='70%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td colspan="2" class='title'>결재</td>				  				  
				  <td width='20%' rowspan="3" class='title'>기간</td>				  				  				  
				  <td colspan="9" class='title'>청구금액</td>				  				  
			    </tr>
				<tr>
				  <td rowspan="2" width='8%' class='title'>탁송관리자</td>
			      <td rowspan="2" width='8%' class='title'>총무팀장</td>			   
			      <td rowspan="2" width='8%' class='title'>탁송료</td>			   
			      <td rowspan="2" width='6%' class='title'>유류비</td>
			      <td rowspan="2" width='5%' class='title'>세차비</td>
			      <td rowspan="2" width='5%' class='title'>세차<br>수수료</td>
			      <td colspan=4 class='title'>기타</td>
			      <td rowspan="2" width='9%' class='title'>합계</td>
			
			  </tr>
			  <tr>				 
			      <td width='5%' class='title'>외부탁송료</td>
			      <td width='5%' class='title'>주차비</td>
			      <td width='5%' class='title'>보증수리<br/>대행</td>
			      <td width='5%' class='title'>검사대행</td>			   
			  </tr>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line' width='30%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
					<td  width='10%' align='center'><%=i+1%>
					<%if(admin_yn.equals("Y")){ %>
					<a href="javascript:parent.cons_cancel('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '<%=ht.get("REQ_DT")%>', '<%=ht.get("BR_ID")%>', '1', '<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()">[d]</a>
					<%}%>
					</td>
					<td  width='25%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>					
					<td  width='30%' align='center'><%=ht.get("OFF_NM")%></td>
					<td  width='20%' align='center'><%=ht.get("BR_NM")%></td>					
					<td  width='15%' align='center'><%=ht.get("CNT")%>건</td>										
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
		<td class='line' width='70%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>											
					<td  width='8%' align='center'>
					  <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
					<a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '<%=ht.get("REQ_DT")%>', '<%=ht.get("BR_ID")%>', '1', '<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a>
					  <%}else{%>
					  <a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '<%=ht.get("REQ_DT")%>', '<%=ht.get("BR_ID")%>', '1', '<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM1")%></a>
					  <%}%>
					</td>
					<td  width='8%' align='center'>					
					  <%//if(String.valueOf(ht.get("BR_NM")).equals("본사")){%>
					  <%if(String.valueOf(ht.get("USER_DT2")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
					<a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '<%=ht.get("REQ_DT")%>', '<%=ht.get("BR_ID")%>', '2', '<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
					  <%	}else{%>-<%}%>
					  <%}else{%>
					  <a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '<%=ht.get("REQ_DT")%>', '<%=ht.get("BR_ID")%>', '2', '<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM2")%></a>
					  <%}%>
					  <%//}%>
					</td>
					<td  width='20%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIN_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("MAX_DT")))%></td>					
					<td  width='8%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>										
					<td  width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>
					<td  width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
					<td  width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_FEE")))%></td>
					<td  width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_OTHER_AMT")))%></td>
					<td  width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
					<td  width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC1_AMT")))%></td>
					<td  width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC2_AMT")))%></td>
					<td  width='9%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
				</tr>
<%			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
//			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("HIPASS_AMT")));
			total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("WASH_FEE")));
			total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("CONS_OTHER_AMT")));
			total_amt12 	= total_amt12 + AddUtil.parseLong(String.valueOf(ht.get("ETC1_AMT")));
			total_amt13 	= total_amt13 + AddUtil.parseLong(String.valueOf(ht.get("ETC2_AMT")));
		}%>
				<tr>											
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>									
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt7)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt11)%></td>			
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt12)%></td>			
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt13)%></td>			
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
				</tr>
			</table>
		</td>
<%	}else{%>
	<tr>
		<td class='line' width='30%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='70%'>
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
