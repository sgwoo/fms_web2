<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
				   	"&sh_height="+height+"";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function insert_payact(){
		var fm = document.form1;
		var w_width  = 850;
		var w_height = 650;
		window.open("pay_a_addact_a.jsp?<%=valus%>&bank_code="+fm.bank_code2.value, "VIEW_PAY_ACT", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");				
	}
	
	function cancel_payact(){
		var fm = document.form1;
		var w_width  = 850;
		var w_height = 650;
		window.open("pay_a_addact_d.jsp?<%=valus%>&bank_code="+fm.bank_code2.value, "VIEW_PAY_ACT", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");				
	}	
	//보기
	function cng_pay_acc(reqseq){
		window.open("pay_a_acc_cng.jsp<%=valus%>&reqseq="+reqseq+"&from_page=/fms2/pay_mng/pay_a_frame.jsp", "VIEW_PAY_LEDGER", "left=10, top=10, width=900, height=350, scrollbars=yes");			
	}
	
	function doc_action(mode, bank_code, doc_no){
		var fm = document.form1;
		fm.mode.value 			= mode;
		fm.doc_no.value 		= doc_no;
		fm.bank_code.value 		= bank_code;		
			
		window.open('about:blank', "PAYDOC", "left=0, top=0, width=1400, height=900, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "PAYDOC";
		fm.action = "pay_a_cms_req_app.jsp";
		fm.submit();
	}	

	function view_pay_ledger_doc(reqseq, p_gubun, p_cd1, p_cd2, p_cd3, p_cd4, p_cd5, p_st1, p_st4, i_cnt){
		var w_width  = 850;
		var w_height = 650;
		var url_etc = '';
		
		//직접등록
		if(p_gubun == '99'){
			w_width  = 900;
			w_height = 400;
			window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");				
		//조회등록
		}else{		
			if(i_cnt == '1'){
				if(p_gubun == '01'){
					w_width  = 900;
					w_height = 700;
					window.open("/fms2/car_pur/pur_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '02'){
					w_width  = 900;
					w_height = 700;
					if(p_cd3 == '7'){
						window.open("/fms2/commi/suc_commi_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}else{
						window.open("/fms2/commi/commi_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}
				}else if(p_gubun == '04'){
					w_width  = 850;
					w_height = 800;
					if(p_st4=='묶음'){
						var lend_id = p_cd1.substring(0,4);
						var rtn_seq = p_cd1.substring(4);
						window.open("/acar/con_debt/debt_c_bank2.jsp<%=valus%>&mode=view&lend_id="+lend_id+"&rtn_seq="+rtn_seq+"&alt_tm="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}else{
							if(p_cd4 != '') url_etc = '&m_id='+p_cd3+'&l_cd='+p_cd4;
							window.open("/acar/con_debt/debt_c.jsp<%=valus%>&mode=view&c_id="+p_cd1+"&alt_tm="+p_cd2+url_etc, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
						}
				}else if(p_gubun == '11'){
					if(p_cd1 == 'null' || p_cd1==p_st1){
						w_width  = 900;
						w_height = 400;
						window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");							
					}else{					
						w_width  = 900;
						w_height = 700;			
						if(p_cd5 != '') url_etc = '&rent_mng_id='+p_cd4+'&rent_l_cd='+p_cd5;			
						window.open("/acar/cus_reg/serv_reg.jsp<%=valus%>&mode=view&car_mng_id="+p_cd1+"&serv_id="+p_cd2+url_etc, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}
				}else if(p_gubun == '21'){
					w_width  = 1000;
					w_height = 800;
					window.open("/acar/fine_mng/fine_mng_frame.jsp<%=valus%>&mode=view&car_mng_id="+p_cd1+"&seq_no="+p_cd2+"&rent_mng_id="+p_cd3+"&rent_l_cd="+p_cd4, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '31'){
					w_width  = 1000;
					w_height = 800;
					window.open("/fms2/cls_cont/lc_cls_u3.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '35'){
					w_width  = 1100;
					w_height = 600;
					window.open("/fms2/lc_rent/lc_c_c_suc_commi.jsp<%=valus%>&mode=pay_view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '07' || p_gubun == '08'){
					w_width  = 1000;
					w_height = 500;					
					window.open("pay_lists.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");
				}else{		
					w_width  = 900;
					w_height = 400;
					window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}
			}else{
				if(p_gubun == '07' || p_gubun == '08'){
					w_width  = 1000;
					w_height = 500;					
					window.open("pay_lists.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");
				}else{		
					w_width  = 1000;
					w_height = 500;
					window.open("pay_file_lists.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");
				}	
			}
		}
	}
			

	
	//송금요청
	function select_abank(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	

		window.open("about:blank", "PAY_LEDGER_ACT", "left=10, top=10, width=1250, height=650, scrollbars=yes");			
		
		if(cnt == 0){
			//집금만처리
			fm.action = "pay_a_cms_bank_req.jsp";
		}else{
			fm.action = "pay_a_cms_req.jsp";		
		}	
						
		fm.target = "PAY_LEDGER_ACT";
		fm.submit();	
	}			
	
	//취소
	function select_cancel(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("1건이상 선택하세요.");
			return;
		}	

		if(!confirm('결재취소 하시겠습니까?')){	return; }
		if(!confirm('다시 확인합니다. 결재취소 하시겠습니까?')){	return; }
		if(!confirm('정말로 결재취소 하시겠습니까?')){	return; }
		if(!confirm('진짜로 결재취소 하시겠습니까?')){	return; }
		
		window.open("about:blank", "PAY_A_CANCEL", "left=10, top=10, width=1000, height=400, scrollbars=yes");			
			
		fm.target = "PAY_A_CANCEL";
		fm.action = "pay_a_cancel_a.jsp";
		fm.submit();	
	}				

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_a_frame.jsp'>  
  <input type='hidden' name='bank_code'	value=''>  
  <input type='hidden' name='doc_no' 	value=''>    
  <input type='hidden' name='mode' 		value=''>    
  
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td>총 <input type='text' name='size' value='' size='4' class=whitenum> 건
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) || (nm_db.getWorkAuthUser("전산팀",user_id))){%>   
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
	  <a href="javascript:select_abank();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_ask_sg.gif" align="absmiddle" border="0"></a>
	  &nbsp;&nbsp;
	  <a href="javascript:select_cancel();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_cancel_gj.gif" align="absmiddle" border="0"></a>
	  &nbsp;
	  <%}%>	
	  
	  <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
	  bank_code : <input type='text' name='bank_code2' value='' size='15' class=text>
	  <input type="button" class="button" id='insertpayact' value='송금처리' onclick="javascript:insert_payact();">	  
	  &nbsp;&nbsp;
	  <input type="button" class="button" id='cancelpayact' value='송금요청초기화' onclick="javascript:cancel_payact();">
	  <%}%>
	  </td>
	</tr>
	<tr>
	  <td>
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
		  <tr>
			<td>
			  <iframe src="pay_a_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
  </table>
</form>
</body>
</html>
