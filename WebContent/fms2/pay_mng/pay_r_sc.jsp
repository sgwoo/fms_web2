<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.pay_mng.*"%>
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
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	String valus = 	"?height="+height+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
				   	"&sh_height="+height+"";
					
	//송금결과 가져오기
	Vector vt =  pm_db.getPayRErpTransList();
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_pay_act(actseq){
		var fm = document.form1;
		fm.actseq.value 	= actseq;
			
		window.open('about:blank', "PAYACT", "left=0, top=0, width=1200, height=600, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "PAYACT";
		fm.action = "pay_r_act_u.jsp";
		fm.submit();
	}	
	
	//계좌관리
	function reg_bank_acc_st(actseq, bank_no){
		var fm = document.form1;
		fm.actseq.value 	= actseq;
		fm.bank_no.value 	= bank_no;
			
		window.open('about:blank', "BANK_ACC_ST", "left=0, top=0, width=500, height=300, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "BANK_ACC_ST";
		fm.action = "pay_r_bank_acc_st.jsp";
		fm.submit();
	}		

	function union_pay_act(actseq){
		var fm = document.form1;
		fm.actseq.value 	= actseq;
			
		window.open('about:blank', "PAYACTUNION", "left=0, top=0, width=1000, height=600, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "PAYACTUNION";
		fm.action = "pay_r_act_union.jsp";
		fm.submit();
	}	
		
	//송금결과등록
	function select_abank_result(){
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
			
		window.open("about:blank", "PAY_LEDGER_ACT_RS", "left=10, top=10, width=950, height=650, scrollbars=yes");			
			
		fm.target = "PAY_LEDGER_ACT_RS";
		fm.action = "pay_r_cms_rs.jsp";
		fm.submit();	
	}				
			
	//엑셀파일
	function select_excel(){
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

		fm.target = "_blank";
		fm.action = "pay_r_excel.jsp";
		fm.submit();	
	}
	
	//삭제하기
	function select_del(){
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
		
		if(!confirm('출금에서 삭제 하시겠습니까?')){	return; }
		if(!confirm('다시 확인합니다. 출금에서 삭제 하시겠습니까?')){	return; }
		if(!confirm('정말로 출금에서 삭제 하시겠습니까?')){	return; }
		if(!confirm('진짜로 출금에서 삭제 하시겠습니까?')){	return; }
		

		fm.target = "i_no";
		fm.action = "pay_r_del_a.jsp";
		fm.submit();	
	}					
	
	//은행연동전송
	function select_bank_put(){
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
				
		if(!confirm('은행연동(비즈파트너)으로 전송하시겠습니까?\n\n출금계좌가 신한은행 140-004-023871 일때만 전송됩니다.')){	return; }
		
		//fm.target = "i_no";
		fm.target = "_blank";
		fm.action = "pay_r_bank_put_a.jsp";
		fm.submit();	
	}					
	
	//은행결과수신
	function select_bank_get(){
		var fm = inner.document.form1;		
		
		if(!confirm('은행연동결과를 수신하시겠습니까?')){	return; }
				
		fm.target = "i_no";
		fm.action = "pay_r_bank_get_a.jsp";
		fm.submit();	
	}			
		
	//은행연동전송-일괄
	function select_bank_del(){
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
				
		if(!confirm('은행연동(비즈파트너)을 취소하시겠습니까?\n\n연동데이타를 삭제합니다.')){	return; }
		if(!confirm('다시 확인합니다. 삭제 하시겠습니까?')){	return; }
		if(!confirm('정말로 삭제 하시겠습니까?')){	return; }
		if(!confirm('진짜로 삭제 하시겠습니까?')){	return; }
		
		fm.target = "i_no";
		fm.action = "pay_r_bank_del_a.jsp";
		fm.submit();	
	}							
	
	//은행연동전송-한건
	function pay_ebank_del(actseq){
		var fm = document.form1;
		fm.actseq.value 	= actseq;			
		fm.target = "i_no";
		fm.action = "pay_r_bank_del_case_a.jsp";
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
  <input type='hidden' name='actseq'    value=''>      
  <input type='hidden' name='bank_no'    value=''>      
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_r_frame.jsp'>  

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) || (nm_db.getWorkAuthUser("전산팀",user_id))){%>   
	   <input type="button" id="" class="button btn-submit" value="송금결과등록" onclick="select_abank_result()"/>
	    <input type="button" id="" class="button btn-submit" value="삭제" onclick="select_del()"/>
	  <%	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id) ){%>
	    <input type="button" id="" class="button btn-submit" value="은행연동전송" onclick="select_bank_put()"/>
	    <input type="button" id="" class="button btn-submit" value="은행결과수신" onclick="select_bank_get()"/> (미수신건:<%=vt_size%>건)
	  <%	}%>
	  <%}%>	    	  
	  </td>
	</tr>
	 
	<tr>
	  <td>
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
		  <tr>
			<td>
			  <iframe src="pay_r_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
  </table>
</form>
</body>
</html>
