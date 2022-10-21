<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	int sh_height = request.getParameter("sh_height")==null?0:AddUtil.parseInt(request.getParameter("sh_height"));//상단길이
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+
				  "&sh_height="+height+"&st_dt="+st_dt+"&end_dt="+end_dt+"";
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//금액확정 : term_yn = 2
	function cls_action( term_yn, bit, mode, rent_mng_id, rent_l_cd, doc_no){
		var fm = document.form1;
		fm.mode.value 			= mode;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.doc_no.value 		= doc_no;
		fm.bit.value 			= bit;
					
		if (fm.bit.value == '완료') {
			fm.action = 'lc_cls_u3.jsp';		
		} else if ( fm.bit.value == '기안' ) {
		  	 fm.action = 'lc_cls_u.jsp';	  //발신처에서 조회
		}  else {
		    if (  term_yn =='0' ) {	//
				fm.action = 'lc_cls_u.jsp';
		    } else if (  term_yn =='2'  ) {	 //금액확정하여 결재중인경우
		    		fm.bit.value 		= "확정";
				fm.action = 'lc_cls_u1.jsp';
		    } else {
		         if (     toInt(fm.mode.value) == 1  ||  toInt(fm.mode.value) == 2 ) {
		      		 fm.action = 'lc_cls_u.jsp';	  //발신처에서 조회
		         } else {		         
		      		 fm.action = 'lc_cls_u1.jsp';	
		         }		     		    
		    } 	
	        }	    
		    
		/*    				
		    } else if ( toInt(fm.mode.value) == 2 && term_yn =='1' ) {	
				fm.action = 'lc_cls_u.jsp';		
		    } else if ( toInt(fm.mode.value) == 1 && term_yn =='1' ) {	
				fm.action = 'lc_cls_u.jsp';			
		   } else {
		   		fm.action = 'lc_cls_u1.jsp';	
		   }	
					
			} else if (  term_yn =='2'  ) {	 //금액확정
				fm.action = 'lc_cls_u2.jsp';
				
			} else if ( toInt(fm.mode.value) == 5 && term_yn =='1' ) {	
				fm.action = 'lc_cls_u1.jsp';	
			} else if ( toInt(fm.mode.value) == 4 && term_yn =='1' ) {	
				fm.action = 'lc_cls_u1.jsp';	
			} else if ( toInt(fm.mode.value) == 3 && term_yn =='1' ) {	
				fm.action = 'lc_cls_u1.jsp';		
			} else if ( toInt(fm.mode.value) == 2 && term_yn =='1' ) {	
				fm.action = 'lc_cls_u.jsp';		
			} else if ( toInt(fm.mode.value) == 1 && term_yn =='1' ) {	
				fm.action = 'lc_cls_u.jsp';			
			}
		
		} */
			
		fm.target = 'd_content';
		fm.submit();
	}
	
	
	//에러로 인한 데이타 삭제
	function cls_action_d(rent_mng_id, rent_l_cd, use_yn){
		var fm = document.form1;
		
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
	
			
		//해지된건 확인 후 삭제처리 
		if ( use_yn == 'N' ) {
			alert("해지처리된 건입니다.  다시 확인하십시요!!!.");			
			if(confirm('그래도 삭제하시겠습니까?')){				
				fm.action='lc_cls_d_a.jsp';					
				fm.target = 'i_no';
				fm.submit();
			}
		} else {
			if(confirm('삭제하시겠습니까?')){				
				fm.action='lc_cls_d_a.jsp';					
				fm.target = 'i_no';
				fm.submit();
			}
		}
				
	}
	
	//금액확정 : term_yn = 2
	/*
	function cls_action_u( term_yn, bit, mode, rent_mng_id, rent_l_cd, doc_no){
		var fm = document.form1;
		fm.mode.value 			= mode;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.doc_no.value 		= doc_no;
		fm.bit.value 			= bit;			
	
	    if (  term_yn =='0' ) {	
			fm.action = 'lc_cls_re_u.jsp';
	//	} else if ( toInt(fm.mode.value) == 3 && term_yn =='1' ) {	
	//		fm.action = 'lc_cls_u1.jsp';		
		} else if ( toInt(fm.mode.value) == 2 && term_yn =='1' ) {	
			fm.action = 'lc_cls_re_u.jsp';		
		} else if ( toInt(fm.mode.value) == 1 && term_yn =='1' ) {	
			fm.action = 'lc_cls_re_u.jsp';			
		} else {
			fm.action = 'lc_cls_re_u.jsp';		
		}	
			
		fm.target = 'd_content';
		fm.submit();
	}
	*/
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}	
	
	function select_rents_ins_excel_com(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("보험을 선택하세요.");
			return;
		}	
				
		if(confirm('배서 요청하시겠습니까?')){
			fm.target = "_blank";
			fm.action = "lc_cls_d_sc_excel_ins_com.jsp";
			fm.submit();
		}
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15" topmargin=0>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/cls_cont/lc_cls_d_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='bit' value=''>    
  <input type='hidden' name='st_dt' value='<%=st_dt%>'> 
  <input type='hidden' name='end_dt' value='<%=end_dt%>'> 
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
		<%if(nm_db.getWorkAuthUser("보험담당",user_id) || nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>		
		&nbsp;&nbsp;
		<input type="button" class="button" value='보험 배서 요청 등록' onclick='javascript:select_rents_ins_excel_com();'>
		<%}%>	    	
	    	
	    	</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="lc_cls_d_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

</form>
</body>
</html>
