<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*,acar.cus_reg.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	Vector vt = cr_db.getCarServDocList(s_kd, t_wd, gubun1, st_dt, end_dt);
	
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
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
  <input type='hidden' name='from_page' value='/fms2/service/serv_doc_frame.jsp'>
  <input type='hidden' name='m1_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
  <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='30%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='10%' class='title' style='height:51'>연번</td>
		                     <td width='25%' class='title'>정산일자</td>				
		                     <td width="15%" class='title'>건수</td>		
		                     <td width="25%" class='title'>업체</td>				  
				</tr>
			</table>
		</td>
		<td class='line' width='70%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td colspan="3" class='title'>결재</td>				  				  
				  <td width='20%' rowspan="2" class='title'>기간</td>				  				  				  
				  <td colspan="5" class='title'>청구금액</td>				  				  
			    </tr>
				<tr>
				  <td width='10%' class='title'>담당자</td>
			      <td width='10%' class='title'>관리팀장</td>
			      <td width='10%' class='title'>총무팀장</td>
			      <td width='12%' class='title'>정비비</td>			
			    
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
					<td  width='10%' align='center'><%=i+1%></td>
					<td  width='25%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JUNG_DT")))%></td>	
					<td  width='15%' align='center'><%=ht.get("CNT")%>건</td>				
					<td  width='25%' align='center'>
					<% if ( String.valueOf(ht.get("ETC")).equals("7") ) { %>스피드메이트	 
					<% } else  if	( String.valueOf(ht.get("ETC")).equals("8") ) { %>두꺼비카센타  
					<% } else  if	( String.valueOf(ht.get("ETC")).equals("9") ) { %>애니카랜드  
					<% } else  if	( String.valueOf(ht.get("ETC")).equals("10") ) { %>타이어휠타운
					<% } else  if	( String.valueOf(ht.get("ETC")).equals("11") ) { %>본동자동차
					<% } else  if	( String.valueOf(ht.get("ETC")).equals("14") ) { %>영남제일자동차   
					<% } else  if	( String.valueOf(ht.get("ETC")).equals("15") ) { %>바로차유리 <% } %>
					</td>										
				</tr>
<%		}%>
				<tr>
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
					<td  width='10%' align='center'>
					  <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
					<a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>',  '<%=ht.get("JUNG_DT")%>', '1', '<%=ht.get("DOC_NO")%>' );" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a>
					  <%}else{%>
					  <a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>',  '<%=ht.get("JUNG_DT")%>', '1', '<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM1")%><%//=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></a>
					  <%}%>
					</td>
					<td  width='10%' align='center'>	
					
					  <%if(String.valueOf(ht.get("USER_DT2")).equals("")){%>
					
					  <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
					<a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("JUNG_DT")%>',  '2', '<%=ht.get("DOC_NO")%>' );" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
					  <%	}else{%>-<%}%>
					  <%}else{%>
					  <a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("JUNG_DT")%>', '2', '<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM2")%><%//=c_db.getNameById(String.valueOf(ht.get("USER_ID2")),"USER")%></a>
					  <%}%>
					
					</td>
					<td  width='10%' align='center'>	
					 
					  <%if(String.valueOf(ht.get("USER_DT3")).equals("")){%> 
					 
					  <%	if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
					<a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("JUNG_DT")%>',  '3', '<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
					  <%	}else{%>-<%}%>
					  <%}else{%>
					  <a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("JUNG_DT")%>', '3', '<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER")%></a>
					  <%}%>
															
					</td>
					<td  width='20%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIN_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("MAX_DT")))%></td>					
					<td  width='12%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CHE_AMT")))%></td>				
					
					
				</tr>
<%			total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CHE_AMT")));
		 
		}%>
				<tr>											
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>					
				
					
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
