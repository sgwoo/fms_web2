<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function ForfeitReg(car_mng_id,rent_mng_id,rent_l_cd){
		var theForm = document.ForfeitRegForm;
		theForm.car_mng_id.value = car_mng_id;
		theForm.rent_mng_id.value = rent_mng_id;
		theForm.rent_l_cd.value = rent_l_cd;
		theForm.target="d_content"
		theForm.action ="../fine_mng/fine_mng_frame.jsp";
		theForm.submit();
	}

	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	function moveTitle(){
	    var X ;
    	document.all.title.style.pixelTop = document.body.scrollTop ;                                                                              
	    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    	document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;       
	}
	function init() {	
		setupEvents();
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	Vector fines = a_fdb.getForfeitAll(gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd);
	int fine_size = fines.size();
%>
<table border=0 cellspacing=0 cellpadding=0 width="1150">
  <tr>
    <td>
      <table border=0 cellspacing=0 cellpadding=0 width="1150">
        <tr id='title' style='position:relative;z-index:1'>
          <td class=line id='title_col0' style='position:relative;'>            			
            <table border=0 cellspacing=1 width="400">
              <tr> 
                <td width=60 class=title>연번</td>
                <td width=60 class=title>구분</td>
                <td width=100 class=title>계약번호</td>
                <td class=title>상호</td>
              </tr>
            </table>
          </td>
          <td class=line>			        	
            <table  border=0 cellspacing=1 width="800">
              <tr> 
                <td width=100 class=title>차량번호</td>
                <td width=140 class=title>차명</td>
                <td width=80 class=title>과실여부</td>
                <td width=140 class=title>위반일자</td>
                <td width=90 class=title>금액</td>
                <td class=title width=90>입금예정일</td>
                <td width=90 class=title>수금일자</td>
                <td class=title width="70">관리담당자</td>
              </tr>
            </table>
          </td>
		</tr>
<%	if(fine_size > 0){%>				
        <tr>
          <td class=line id='D1_col' style='position:relative;'>            			
            <table border=0 cellspacing=1 width="400">
              <%		for(int i = 0 ; i < fine_size ; i++){
			Hashtable fine = (Hashtable)fines.elementAt(i);%>
              <tr> 
                <td width=60 align="center"><%=i+1%></td>
                <td width=60 align="center"><span title="<%=f_bean.getFirm_nm()%>"><%=Util.subData(f_bean.getFirm_nm(),10)%></span></td>
                <td width=100 align="center"><span title="<%=f_bean.getFirm_nm()%>"><a href="javascript:ForfeitReg('<%=f_bean.getCar_mng_id()%>','<%=f_bean.getRent_mng_id()%>','<%=f_bean.getRent_l_cd()%>')"><%=f_bean.getRent_l_cd()%></a></span></td>
                <td align="center"><span title="<%=f_bean.getFirm_nm()%>"><%=Util.subData(f_bean.getFirm_nm(),10)%></span></td>
              </tr>
            </table>
          </td>            		            		
          <td class=line>            			
            <table border=0 cellspacing=1 width="800">
              <%		for(int i = 0 ; i < fine_size ; i++){
			Hashtable fine = (Hashtable)fines.elementAt(i);%>
              <tr> 
                <td width=100 align="center">&nbsp;<span title="<%=f_bean.getCar_name()%>"><%=f_bean.getCar_no()%></span></td>
                <td width=140><span title="<%=f_bean.getCar_name()%>"><%=Util.subData(f_bean.getCar_name(),11)%></span></td>
                <td width=80 align="center"><%=f_bean.getFault_st_nm()%></td>
                <td width=140 align="center"><%=f_bean.getVio_dt_view()%></td>
                <td width=90 align="left"><%=f_bean.getPaid_st_nm()%>&nbsp;</td>
                <td width=90 align="center"><%=f_bean.getPaid_st_nm()%></td>
                <td width=90 align="center"><%=f_bean.getColl_dt()%></td>
                <td align="center" width="70"><%=f_bean.getColl_dt()%></td>
              </tr>
              <%	}%>
            </table>
          </td>            		            		
        </tr>
<%	}else{%>                     
        <tr>
	      <td class='line' width='400' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='400'>
              <tr>
		  		<td align='center'>등록된 데이타가 없습니다</td>
		      </tr>
	        </table>
	      </td>
	      <td class='line' width='800'>			
            <table border="0" cellspacing="1" cellpadding="0" width='800'>
              <tr>
		        <td>&nbsp;</td>
		      </tr>
	        </table>
	      </td>
        </tr>
<% 	}%>				
      </table>
    </td>
  </tr>
</table>
<form action="./forfeit_i_frame.jsp" name="ForfeitRegForm" method="post">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="f_st" value="<%=f_st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
</form>
</body>
</html>