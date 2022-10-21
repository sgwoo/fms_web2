<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
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
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	if(nm_db.getWorkAuthUser("아마존카이외",user_id)){
		s_kd = "8";
	}
	
	Vector vt = t_db.getTintReqDocList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//용품관리 보기
	function view_est(m_id, l_cd){
		window.open("/fms2/lc_rent/view_est.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=board", "VIEW_STAT", "left=100, top=100, width=620, height=400, scrollbars=yes");		
	}
	//용품관리 보기
	function view_tint(m_id, l_cd){
		window.open("/fms2/car_pur/view_tint.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_TINT", "left=0, top=0, width=1020, height=500, scrollbars=yes");		
	}
	
	//희망번호 등록
	function reg_estcarno(m_id, l_cd){
		window.open("reg_estcarno.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=board", "REG_ESTCARNO", "left=100, top=100, width=620, height=400, scrollbars=yes");					
	}
	
	//거래처 보기 
	function view_client(rent_mng_id, rent_l_cd, r_st, car_mng_id)
	{
		var SUBWIN= "/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
		window.open(SUBWIN, "View_Client", "left=50, top=50, width=720, height=600, resizable=yes, scrollbars=yes");
	}

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}	
		
	//용품보기
	function tint_action(tint_no){
		var fm = document.form1;
		fm.tint_no.value 		= tint_no;			
		fm.action = 'tint_reg_step3.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
			
		
	//용품비용 기안넘기기
	function select_tint(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					var idx = parseInt(idnum.substr(13),10);
					<%	if(vt_size == 1){%>
					if(fm.cont_st1.value == '미확인')		{ alert('담당자 미환인 상태입니다.'); 					return; }
					<%	}else{%>					
					if(fm.cont_st1[idx].value == '미확인')	{ alert((idx+1)+'번 담당자 미환인 상태입니다.'); 		return; }
					<%	}%>					
					cnt++;					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("청구할 용품을 선택하세요.");
			return;
		}	
		
		if(!confirm('비용청구하시겠습니까?')){	return; }
		
		fm.req_dt.value = document.form1.req_dt.value;
		fm.target = "i_no";
		//fm.target = "_blank";
		fm.action = "tint_r_doc_a.jsp";
		fm.submit();	
	}					
	
	//용품비용 청구확인 문자발송
	function conf_sms_tint(){
		var fm = document.form1;			
		if(!confirm('청구확인 메모를 발송하시겠습니까?')){	return; }		
		fm.target = "i_no";
		//fm.target = "_blank";
		fm.action = "tint_r_sms_a.jsp";
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
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/tint/tint_r_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) || (nm_db.getWorkAuthUser("전산팀",user_id))){%>   
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  <img src="/acar/images/center/arrow_day_cg.gif" align=absmiddle border="0">&nbsp;&nbsp;&nbsp;<input type='text' name="req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text'>&nbsp;&nbsp;
	  <a href="javascript:select_tint();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_cg_np.gif" align="absmiddle" border="0"></a>
	  &nbsp;
	  <%}%>	  
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) || (nm_db.getWorkAuthUser("전산팀",user_id))){%>   
	  <a href="javascript:conf_sms_tint();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_sms_conf.gif" align="absmiddle" border="0"></a><%}%>
	  </td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="tint_r_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
