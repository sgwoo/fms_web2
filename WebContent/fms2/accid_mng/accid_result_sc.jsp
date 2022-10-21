<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//@ author : JHM - 사고처리결과문서관리
	
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
	String end_dt	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//거래처 보기 
	function view_client(rent_mng_id, rent_l_cd, r_st)
	{
		var SUBWIN= "/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
		window.open(SUBWIN, "View_Client", "left=50, top=50, width=820, height=800, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//문서보기
	function doc_action(mode, rent_mng_id, rent_l_cd, car_mng_id, accid_id, doc_no){
		var fm = document.form1;
		fm.mode.value 			= mode;
		fm.rent_mng_id.value 		= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.car_mng_id.value 		= car_mng_id;
		fm.accid_id.value 		= accid_id;
		fm.doc_no.value 		= doc_no;
			
		if(doc_no == ''){
			fm.action = 'accid_result_c.jsp';
		}else{
			fm.action = 'accid_result_c.jsp';
		}
		
		fm.target = 'd_content';
		fm.submit();
	}
	

	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//기안넘기기
	function select_doc_action(){
		var fm = inner.document.form1;	
		
		var ccnt=	 toInt(parseDigit(fm.a_size.value));
	
		var len=fm.elements.length;
				
		var index, str;
		var cnt=0;		
		var idnum="";
					
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];	
								
			if(ck.name == "ch_cd"){	
				if(ck.checked == true){
										
					idnum=ck.value;	
					index = idnum.indexOf("^");								
					str =  idnum.substring(0, index);
				
					var idx = 	 toInt(parseDigit(str));
					
			//	    alert(idnum);				  
			//	    alert(fm.chk_cnt[idx - 1].value);
				    
					if( ccnt == 1 ){
						if(fm.chk_cnt.value != '0')					{ alert('조건을 다시 확인하세요!!!.'); 					return; }													
					}else{					
						if(fm.chk_cnt[idx].value != '0')			{ alert((idx+1)+'번 조건을 다시 확인하세요!!!.'); 		return; }	
					}
									
					cnt++;
					
				}								
			}						
		}	
				
		if(cnt == 0){
			alert("데이타를 확인하세요!!!.");
			return;
		}	
				
		if(!confirm('결재하시겠습니까?')){	return; }
		
		fm.target = "i_no";
		//fm.target = "_blank";
		fm.action = "accid_doc_sanction_select.jsp";
		fm.submit();	
	}				
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/accid_mng/accid_result_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='car_mng_id' value=''>
  <input type='hidden' name='accid_id' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	<td>
	    <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size'  size='4' class=whitenum> 건</span>	    
	    <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("지점장",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("부산사고종결부담당",user_id)){%>   
	    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    <a href="javascript:select_doc_action();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title="일괄결재하기"><img src="/acar/images/center/button_iggj.gif" align="absmiddle" border="0"></a>
	    <%}%>
	</td>
    </tr>
    <tr>
        <td>
	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
		    <td>
			<iframe src="accid_result_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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
