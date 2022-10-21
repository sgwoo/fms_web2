<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_ts.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function doc_action(scan_doc_cnt, chk_cnt, mode, rent_mng_id, rent_l_cd, doc_no, doc_bit, car_off_nm){
		var fm = document.form1;
		fm.mode.value 			= mode;
		fm.rent_mng_id.value 		= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.doc_no.value 		= doc_no;
			
		if(car_off_nm == ''){
			alert('중고차판매처가 등록되지 않았습니다. 계약관리에서 먼저 등록하세요.');
			return;
		}
		
		if(doc_no == ''){
			fm.action = 'pur_doc_ac_i.jsp';
		}else{
			fm.action = 'pur_doc_ac_u.jsp';
			
			if(doc_bit > 4 || '<%=user_id%>'=='000004'){
				//fm.action = 'pur_doc_ac_c.jsp';
			}
		}
		
		fm.target = 'd_content';
		fm.submit();
	}
	
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}	
	
	//출고계약 선택
	function select_purs_amt(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var purs_amt = 0;
		var purs_dt  = "";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;					
					idnum=ck.value;
					var ch_split = idnum.split("/");					
					purs_dt = ch_split[1];
					if(purs_dt == document.form1.est_dt.value || document.form1.est_dt.value == ''){
						purs_amt = purs_amt + toInt(ch_split[0]);
					}					
				}
			}
		}	
		if(cnt == 0){
		 	document.form1.est_amt.value = 0;
		}			
		document.form1.est_amt.value = parseDecimal(purs_amt);
	}	
	
	//출고계약 선택
	function select_purs_dt(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var purs_amt = 0;
		var purs_dt  = "";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			idnum=ck.value;			
			var ch_split = idnum.split("/");					
			purs_dt = ch_split[1];			
			if(purs_dt == document.form1.est_dt.value || document.form1.est_dt.value == ''){
				ck.checked = true;
			}else{
				ck.checked = false;
			}			
		}	
		select_purs_amt();
	}			
	
//-->
</script>

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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_doc_ac_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name='est_dt' onChange='javascript:select_purs_dt();'>
		    <option value=''>전체</option>		    
          	    <%for (int i = 0 ; i < 4 ; i++){
          	    		String est_dt = c_db.addDay(AddUtil.getDate(4), i);
          	    		String est_dt_nm = "";
          	    		if(i==0) est_dt_nm = "오늘";
          	    		if(i==1) est_dt_nm = "내일";
          	    		if(i==2) est_dt_nm = "모레";
          	    		if(i==3) est_dt_nm = "글피";
          	    		
          	    %>
		    <option value='<%=est_dt%>'><%=est_dt_nm%></option>
          	    <%}%>
	        </select>
	        &nbsp;&nbsp;&nbsp;
		* 지출예상금액 : <input type='text' name='est_amt' maxlength='10' value='' class='whitenum' size='10'>원		
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="pur_doc_ac_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>	
    <tr>
	    <td>※ 중고차대금문서처리 미결리스트에 안나오는 계약은 계약관리에서 중고차판매처에 입력 여부를 확인하세요.</td>
	</tr>	
</table>
</form>
</body>
</html>
