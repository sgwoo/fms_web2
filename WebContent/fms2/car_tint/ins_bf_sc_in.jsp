<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	== null ? "" : request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")		== null ? "" : request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		== null ? "" : request.getParameter("br_id");
	
	String s_kd 			 = request.getParameter("s_kd")				== null ? "" : request.getParameter("s_kd");
	String t_wd 			 = request.getParameter("t_wd")				== null ? "" : request.getParameter("t_wd");
	String andor 			 = request.getParameter("andor")				== null ? "" : request.getParameter("andor");
	String gubun1			 = request.getParameter("gubun1")			== null ? "" : request.getParameter("gubun1");
	String gubun2			 = request.getParameter("gubun2")			== null ? "" : request.getParameter("gubun2");
	String gubun3			 = request.getParameter("gubun3")			== null ? "" : request.getParameter("gubun3");
	String st_dt 			 = request.getParameter("st_dt")				== null ? "" : request.getParameter("st_dt");
	String end_dt 			 = request.getParameter("end_dt")			== null ? "" : request.getParameter("end_dt");
	String sort 				 = request.getParameter("sort")					== null ? "" : request.getParameter("sort");
	String rent_or_lease = request.getParameter("rent_or_lease")	== null ? "" : request.getParameter("rent_or_lease");
	String con_f 			 = request.getParameter("con_f")			   	== null ? "" : request.getParameter("con_f");
	
	int sh_height = request.getParameter("sh_height") == null ? 0 : Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = t_db.getCarTintInsBlackFileList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort, rent_or_lease, con_f);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
	
	// 보험 변경 II 등록
	function select_c2_ins_excel(){
		if(<%= vt_size%> == 0) {
			alert('등록할 데이터가 없습니다.');
			return;
		}
		if(confirm("보험 변경 II 등록을 하시겠습니까?")){
			var fm = document.form1;
			fm.target = "_blank";
			fm.action = "ins_bf_a.jsp";
			fm.submit();
		}
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
  <input type='hidden' name='from_page' value='ins_bf_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='rent_or_lease' value='<%= rent_or_lease%>'>    
  <input type='hidden' name='con_f' value='<%= con_f%>'>
 <table style="width: 100%;">
 	<tr>
 		<td style="text-align: left;">
 			<input type="button" class="button" value='보험 변경 II 등록' onclick='javascript: select_c2_ins_excel();'>
 			<b>렌터카공제조합 영업용 자동차 블랙박스 할인요율 폐지 2020.10.15<b>
 		</td>
 	</tr>
 </table>
<table border="0" cellspacing="0" cellpadding="0" width='1790'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='550' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='50' class='title' style='height:51'>연번</td>    
		    <td width='100' class='title'>차량번호</td>						
        	<td width='150' class='title'>차대번호</td>
        	<td width='150' class='title'>차종</td>		    
        	<td width='100' class='title'>차량등록일</td>		    
		</tr>
	    </table>
	</td>
	<td class='line' width='1240'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="4" class='title' style='height:24'>블랙박스설치내역</td>
		    <td rowspan="2" width="100" class='title'>첨부파일</td>
		    <td colspan="4" class='title' style='height:24'>가입보험</td>
		    <td rowspan="2" width="90" class='title'>최초영업자</td>
		    <td rowspan="2" width="70" class='title'>렌트/리스</td>
		</tr>
		<tr>
		    <td width='130' class='title' style='height:23'>제조사</td>
		    <td width='100' class='title'>모델명</td>
		    <td width='170' class='title'>일련번호</td>
		    <td width='100' class='title'>설치일자</td>	
		    <td width='100' class='title'>보험사</td>
		    <td width='180' class='title'>피보험자</td>
		    <td width='100' class='title'>보험시작일</td>
		    <td width='100' class='title'>블랙박스여부</td>	
		</tr>
	    </table>
	</td>
    </tr>
    <%	if(vt_size > 0){%>
    <tr>
	<td class='line' width='550' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		<tr>
		    <td width='50' align='center'><%=i+1%></td>		    
		    <td width='100' align='center'><%=ht.get("CAR_NO")%></td>
		    <td width='150' align='center'><%=ht.get("CAR_NUM")%></td>		
		    <td width='150' align='center'><%=ht.get("CAR_NM")%></td>    
		    <td width='100' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>    
		</tr>
		<%	}%>
	    </table>
	</td>
	<td class='line' width='1240'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>			
		<tr>
	        <td width='130' align='center'><span title='<%=ht.get("COM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("COM_NM")), 14)%></span></td>
		    <td width='100' align='center'><span title='<%=ht.get("MODEL_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("MODEL_NM")), 8)%></span></td>
		    <td width='170' align='center'><%=ht.get("SERIAL_NO")%></td>					
		    <td width='100' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SUP_DT")))%></td>	
		    <td width='100' align='center'>
		        <%if(!String.valueOf(ht.get("ATTACH_FILE_SEQ1")).equals("")){%>
		        <a href="javascript:openPopP('<%=ht.get("ATTACH_FILE_TYPE1")%>','<%=ht.get("ATTACH_FILE_SEQ1")%>');" title='보기' ><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>&nbsp;		        
		        <%}%>
		        <%if(!String.valueOf(ht.get("ATTACH_FILE_SEQ2")).equals("")){%>
		        <a href="javascript:openPopP('<%=ht.get("ATTACH_FILE_TYPE2")%>','<%=ht.get("ATTACH_FILE_SEQ2")%>');" title='보기' ><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>&nbsp;		        
		        <%}%>		    
		    </td>									
		    <td width='100' align='center'><%=ht.get("INS_COM_NM")%></td>					
		    <td width='180' align='center'><%=ht.get("CON_F_NM")%></td>					
		    <td width='100' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INS_START_DT")))%></td>	
		    <td width='100' align='center'><%=ht.get("BLACKBOX_YN")%></td>					
		    <td width='90' align='center'><%=ht.get("BUS_NM")%></td>					
		    <td width='70' align='center'>
		    	<%if(ht.get("CAR_ST").equals("1"))%> 렌트 
		    	<%else if(ht.get("CAR_ST").equals("3"))%> 리스
		    </td>					
		</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	
    <%	}else{%>                     
    <tr>
	<td class='line' width='300' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='970'>
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

