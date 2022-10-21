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
	

	Vector vt = cs_db.getConsignmentPurReqDocList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
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
  <input type='hidden' name='from_page' value='/fms2/cons_pur/consp_doc_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width='900'>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='250' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='40' class='title' style='height:51'>연번</td>
		    <td width='150' class='title'>탁송업체</td>
		    <td width="60" class='title'>건수</td>				  
		</tr>
	    </table>
	</td>
	<td class='line' width='650'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="3" class='title'>결재</td>				  				  
		    <td width='200' rowspan="2" class='title'>기간</td>
		    <td width='150' rowspan="2" class='title'>청구금액</td>
		</tr>
		<tr>
		    <td width='100' class='title'>기안일자</td>
		    <td width='100' class='title'>탁송관리자</td>
		    <td width='100' class='title'>총무팀장</td>		    
		</tr>
	    </table>
	</td>
    </tr>
<%	if(vt_size > 0)	{%>
    <tr>
	<td class='line' width='250' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
		<tr>
		    <td  width='40' align='center'><%=i+1%></td>
		    <td  width='150' align='center'><%=ht.get("OFF_NM")%></td>
		    <td  width='60' align='center'>
		        <%if(nm_db.getWorkAuthUser("아마존카이외",user_id)){%>
		        <a href="javascript:parent.cons_action2('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '1', '<%=ht.get("DOC_NO")%>', '<%=ht.get("DLV_YM")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><%=ht.get("CNT")%>건</a>
		        <%}else{%>
		        <%=ht.get("CNT")%>건
		        <%}%>
		    </td>										
		</tr>
<%		}%>
		<tr>		    
		    <td class='title'>&nbsp;</td>
		    <td class='title'>&nbsp;</td>
		    <td class='title'>&nbsp;</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='650'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
		<tr>	
		    <td  width='100' align='right'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USER_DT1")))%></td>															
		    <td  width='100' align='center'>
		        <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
		            <%	if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>
			        <a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '1', '<%=ht.get("DOC_NO")%>', '<%=ht.get("DLV_YM")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a>
			    <%	}else{%>-<%}%>
			<%}else{%>
			    <a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '1', '<%=ht.get("DOC_NO")%>', '<%=ht.get("DLV_YM")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM1")%></a>
			<%}%>
		    </td>
		    <td  width='100' align='center'>					
			<%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT2")).equals("")){%>
			    <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
			        <a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '2', '<%=ht.get("DOC_NO")%>', '<%=ht.get("DLV_YM")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
			    <%	}else{%>-<%}%>
			<%}else{%>
			        <a href="javascript:parent.cons_action('<%=ht.get("REQ_CODE")%>', '<%=ht.get("OFF_ID")%>', '2', '<%=ht.get("DOC_NO")%>', '<%=ht.get("DLV_YM")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM2")%></a>
			<%}%>
		    </td>
		    <td  width='200' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIN_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("MAX_DT")))%></td>					
		    <td  width='150' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT1")))%></td>					
		</tr>
<%			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT1")));
			
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
    </tr>	
<%	}else{%>
    <tr>
	<td class='line' width='250' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
			<%if(t_wd.equals("")){%>검색어를 입력하십시오.
			<%}else{%>등록된 데이타가 없습니다<%}%></td>
		</tr>
	    </table>
	</td>
	<td class='line' width='650'>
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
