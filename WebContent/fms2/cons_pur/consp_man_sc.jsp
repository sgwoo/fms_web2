<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "07", "04");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
					
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = cs_db.getConsignmentPurManList("", gubun2);
	int vt_size = vt.size();	
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function modify(mode, idx){
		var fm = document.form1;		
		fm.mode.value 	= mode;		
		fm.idx.value 	= idx;	
		
		if(fm.man_nm[idx].value == ''){ 	alert('성명을 입력하십시오.'); 		fm.man_nm[idx].focus(); 	return; }
		if(fm.man_ssn[idx].value == ''){ 	alert('생년월일을 입력하십시오.'); 	fm.man_ssn[idx].focus(); 	return; }
		if(fm.man_tel[idx].value == ''){ 	alert('전화번호를 입력하십시오.'); 	fm.man_tel[idx].focus(); 	return; }
			
		fm.action = 'consp_man_a.jsp';				
		fm.target = 'i_no';
		fm.submit();
	}
	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
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
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/cons_pur/consp_man_frame.jsp'>
  <input type='hidden' name='idx'  value=''>
  <input type='hidden' name='mode' value=''>      
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='3%' rowspan="3" class='title'>연번</td>
		    <td width='15%' rowspan="3" class='title'>제조사</td>
		    <td width='10%' rowspan="3" class='title'>출고사무소</td>
		    <td colspan="5" class='title'>탁송업체</td>				  				  
		    <td width='10%' rowspan="3" class='title'>등록일자</td>
		    <td width='6%' rowspan="3" class='title'>수정</td>
		    <td width='6%' rowspan="3" class='title'>-</td>
		</tr>
		<tr>
		    <td width='10%' rowspan="2" class='title'>상호</td>
		    <td width='10%' rowspan="2" class='title'>전화번호</td>		    
		    <td colspan="3" class='title'>출고대리인</td>				  				  
		</tr>
		<tr>
		    <td width='10%' class='title'>성명</td>
		    <td width='10%' class='title'>생년월일</td>
		    <td width='10%' class='title'>전화번호</td>		    
		</tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
		<tr>
		    <input type='hidden' name='car_comp_id' 	value='<%=ht.get("CAR_COMP_ID")%>'>
		    <input type='hidden' name='dlv_ext' 	value='<%=ht.get("DLV_EXT")%>'>
		    <input type='hidden' name='off_id' 	        value='<%=ht.get("OFF_ID")%>'>
		    <td align='center'><%=i+1%></td>
		    <td align='center'><%=ht.get("CAR_COMP_NM")%></td>
		    <td align='center'><%=ht.get("DLV_EXT")%></td>
		    <td align='center'><%=ht.get("OFF_NM")%></td>
		    <td align='center'><%=ht.get("OFF_TEL")%></td>
		    <td align='center'><input type='text' size='10' name='man_nm' maxlength='15' class='default' value='<%=ht.get("MAN_NM")%>'></td>
		    <td align='center'><input type='text' size='14' name='man_ssn' maxlength='8' class='default' value='<%=ht.get("MAN_SSN")%>'></td>
		    <td align='center'><input type='text' size='13' name='man_tel' maxlength='15' class='default' value='<%=ht.get("MAN_TEL")%>'></td>
		    <td align='center'><%=ht.get("REG_DT")%></td>
		    <td align='center'><a href="javascript:modify('수정', '<%=i%>');"><img src=/acar/images/center/button_in_modify.gif border=0 align=absmiddle></a></td>
		    <td align='center'><%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%><a href="javascript:modify('삭제', '<%=i%>');"><img src=/acar/images/center/button_in_delete.gif border=0 align=absmiddle></a><%}%></td>		    
		</tr>
<%		}%>		
	    </table>
	</td>
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
