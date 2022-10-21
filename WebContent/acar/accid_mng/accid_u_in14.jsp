<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"13":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
		
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
		
	String req_id = user_id;
		
	//소송	
	AccidSuitBean as_bean = as_db.getAccidSuitBean(c_id, accid_id);
		

	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
	if ( !as_bean.getReq_id().equals("")){
	 	req_id = as_bean.getReq_id();
	}
	
	int size = 0;
	
	String content_code = "ACCIDENT";
	String content_seq  = c_id+""+accid_id;
	
	//System.out.println(content_seq);

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	//문서품의  -  과실미확정소송  : 43
	DocSettleBean doc = d_db.getDocSettleCommi("43", c_id+""+accid_id);
	String doc_no = doc.getDoc_no();

	//기안자
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	int suit_cnt = 0;
				
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(g_gubun){	
		var fm = document.form1;
					
		fm.gubun.value = g_gubun;
		fm.mode.value = 14;
		
		if(fm.req_dt.value == ''){ alert('요청일자를 입력하십시오.'); return; }		
		if(fm.req_id.value == ''){ alert('요청자를 입력하십시오.'); return; }
		
		if ( g_gubun == '2') {			
			if(fm.suit_type[0].checked == false  &&  fm.suit_type[1].checked == false  && fm.suit_type[2].checked == false){ alert('소송종류를 선택하십시오.'); return; }
			if(fm.suit_type[0].checked == true ||  fm.suit_type[1].checked == true ) {
				if(fm.suit_dt.value == ''){ alert('접수일을 입력하십시오.'); return; }		
			}
				
		}
		
		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.target = "i_no";
		fm.submit();
	}		
	
	//스캔등록
	function scan_reg(gubun){
	
		window.open("accid_reg_scan.jsp?c_id=<%=c_id%>&accid_id=<%=accid_id%>&gubun="+gubun +"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
		
	function message_reg(gubun){ //관련서류 등록 후 요청해야 함. 
		var fm = document.form1;
		
		fm.gubun.value = gubun;
		
		if ( gubun == '9') {
		//	if (<%=suit_cnt%> < 1 ) {
		//		alert('소장 등록 후  요청하세요.'); 
		//		return; 			
		//	}
							
			if(confirm('메세지를 보내시겠습니까?')){	
				fm.action = "accid_msg_a.jsp";		
				fm.target='i_no';
				fm.submit();
			}			
			
		} else {
		
			if (<%=attach_vt_size%> < 2) {
				alert('소송관련 서류를 등록 후 요청하세요.'); 
				return; 			
			}
							
			if(confirm('결재요청하시겠습니까?')){	
				fm.action = "accid_msg_a.jsp";		
				fm.target='i_no';
				fm.submit();
			}							
		}		
	}
		
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
			
		// 종료결재인 경우 종료일자 check
		if (doc_bit == '5' || doc_bit == '6' ) {	
			if(fm.mean_dt.value == '')				{ alert('판결일자를 입력하십시오!!'); 		fm.mean_dt.focus(); 		return; }
		} else 	if (doc_bit == '1' || doc_bit == '2' || doc_bit == '3' || doc_bit == '4'  ) {	
				if(fm.mean_dt.value != '')				{ alert('판결일자를 확인하세요!!'); 		fm.mean_dt.focus(); 		return; }	
		}
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='suit_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	
	//결재요청 취소하기
	function sanction_req_cancel(){
		var fm = document.form1;	
		
		if(fm.sanction_req_cancel.value == '')				{ alert('취소사유를 입력하세요!!'); 		fm.sanction_req_cancel.focus(); 		return; }	
		
		if(confirm('결재요청 취소하시겠습니까?')){	
			fm.gubun.value = "cancel";
			fm.action = "accid_msg_a.jsp";		
			fm.target='i_no';
			fm.submit();
		}	
	}	
	
    function send_msg(c_id, accid_id, m_id, l_cd){
		var url = 'accid_u_in14_send.jsp?c_id='+c_id+'&accid_id='+accid_id+'&m_id='+m_id+'&l_cd='+l_cd;
		var specs = "left=10,top=10,width=572,height=166";
		  specs += ",toolbar=no,menubar=no,status=no,scrollbars=no,resizable=no";
		 window.open(url, "popup", specs); 
	}
	
	
//-->
</script>

</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
 <form action="accid_u_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun' value=''>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>  
    <input type='hidden' name='go_url' value='<%=go_url%>'>  	
 <input type='hidden' name='doc_bit' > 
 <input type='hidden' name="doc_no" 		value="<%=doc_no%>">    	
	
	<tr><td class=h></td></tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>담당자 요청</span> </td>
    	<td align="right">         
        <%	if((auth_rw.equals("1") || auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) && a_bean.getSettle_st().equals("0") && as_bean.getReq_dt().equals("") ){%>
        <a href='javascript:save(1)' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a> 
        <%	}%>      
        </td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    
     <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
               <tr> 
                    <td class=title width=9%>요청일</td>
                    <td> 
					  <%if(as_bean.getReq_dt().equals("") ){%>	
                      &nbsp;<input type="text" name="req_dt" value="<%=AddUtil.ChangeDate2(as_bean.getReq_dt())%>" size="11" class=text   onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="11">
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(as_bean.getReq_dt())%>
					  <input type='hidden' name="req_dt" value="<%=as_bean.getReq_dt()%>">
					  <%}%>
                    </td>
                    <td class=title width=9%>요청자</td>   
                    <td colspan="3">&nbsp;
                    <select name='req_id'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(req_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                      
                    </td>          					
                </tr>
                
                <tr> 
                    <td class=title>요청 특이사항</td>
                    <td colspan="5" height="76"> 
                     &nbsp;<textarea name="req_rem" cols="140" rows="3"><%=as_bean.getReq_rem()%></textarea>
                    </td>
                </tr>
                <%
                	String judge_filetype = "";
                	String judge_filename = "";
                	String judge_seq = "";
                
                %>
                <%if(attach_vt.size() > 0){%>
				<%for(int i=0; i< attach_vt.size(); i++){
                		Hashtable ht = (Hashtable)attach_vt.elementAt(i);      
                		
                	//	System.out.println( String.valueOf(ht.get("CONTENT_SEQ")).substring(12) );
                		if ( String.valueOf(ht.get("CONTENT_SEQ")).substring(12).equals("5") )  continue;
                		int file_gubun =  Integer.parseInt((String.valueOf(ht.get("CONTENT_SEQ")).substring(12)));
                		if(file_gubun == 6){
                			judge_filetype = String.valueOf(ht.get("FILE_TYPE"));
                			judge_seq = String.valueOf(ht.get("SEQ"));
                			judge_filename = String.valueOf(ht.get("FILE_NAME"));
                			continue;
                		}
                		
                		                 		
                    %>
				<tr> 
					 <td align='center'class='title'>
					 <% if ( i== 0 )  {%>
					    사고사실확인서
					 <% } else if ( i==1 ) {%>
					 사고수리견적서
					 <% } else if ( i==2 ) {%>
					  기타1
					 <% } else if ( i==3 ) {%>
					  기타2
					 <% } %>					 
					 </td>
					 <td colspan="5" >&nbsp;&nbsp;
					 <%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>			
					 <a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><%=ht.get("FILE_NAME")%></a>
					 <%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					 </td>
				</tr>
				<%}%>
				<%if(attach_vt.size() < 4){%>
				<tr>
					<td align='center'class='title'>첨부파일 추가</td>
					<td colspan="5">&nbsp;&nbsp;
					<% if ( !as_bean.getReq_dt().equals("") ) { %>
						<a href="javascript:scan_reg(1)"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					<% } %>
				    </td>
				
				<%} %>
			<%}else{%>
				<tr>
					<td align='center'class='title'>첨부파일</td>
					<td colspan="5" >&nbsp;&nbsp;
					<% if ( !as_bean.getReq_dt().equals("") ) { %>
						<a href="javascript:scan_reg(1)"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
				    <% } %>
				    </td>
				</tr>
							
			<%}%>
			
				<tr>
					<td align='center'class='title'>판결문</td>
					<td colspan="5">&nbsp;&nbsp;
					<% if(!judge_filetype.equals("")){ %>
					<a href="javascript:openPopF('<%=judge_filetype%>','<%=judge_seq%>');" title='보기' ><%=judge_filename%></a>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=judge_seq%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
					<%}else{ %>
					<a href="javascript:scan_reg(2)"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					<%}%>
				    </td>
				</tr>
            
			 </table>
		</td>	    								
     </tr>     
     
     <tr>
	    <td align='center'>	
	   	   <!-- 파일 첨부후 요청해야 함 --> 
         <% if ( !as_bean.getReq_dt().equals("") && as_bean.getDoc_dt().equals("")  ) { %>
                  <a href="javascript:message_reg(1)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_gjyc.gif align=absmiddle border=0></a>
         <%  } %>  
                      
	    </td>
	</tr>			
	
    <tr>
        <td></td>
    </tr>	
                		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>처리 진행상황</span></td>
        <td align="right">         
        
    
	        <%	if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id)){%>   
	              
        			<a href='javascript:save(2)' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
        	<%} %>      
       
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>소송종류</td>
                    <td colspan="5" >&nbsp;
                    <input type="radio" name="suit_type" value="1" <%if(as_bean.getSuit_type().equals("1")){%> checked <%}%>>분쟁조정심의위원회
					<input type="radio" name="suit_type" value="2" <%if(as_bean.getSuit_type().equals("2")){%> checked <%}%>>민사소송
					<input type="radio" name="suit_type" value="N" <%if(as_bean.getSuit_type().equals("N")){%> checked <%}%>>소송미진행
                    </td>
                  
            
                
				<tr> 
                 <%if(attach_vt.size() > 0){%>
				    <%for(int i=0; i< attach_vt.size(); i++){
                		Hashtable ht = (Hashtable)attach_vt.elementAt(i);      
                                      
                		if ( !String.valueOf(ht.get("CONTENT_SEQ")).substring(12).equals("5") )  continue;
                		
                		suit_cnt = suit_cnt + 1;	
                     %>
               
					 <td align='center' class='title'  width=9% >소장</td>
					 <td>&nbsp;&nbsp;
					 <%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>			
					 <a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><%=ht.get("FILE_NAME")%></a>
					 <%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					 </td>
			    <% } %>
			    <% if ( suit_cnt < 1) { %>			    
					<td class='title'  width=9% >소장</td>
					<td>&nbsp;&nbsp;
					<% // if ( !as_bean.getSuit_dt().equals("") ) { %>
						<a href="javascript:scan_reg(5)"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
				    <%// } %>
				    </td>
				<% }  %>
			<%}else{%>
					<td class='title'  width=9% >소장</td>
					<td>&nbsp;&nbsp;
						<a href="javascript:scan_reg(5)"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>				  
				    </td>
			
			<%}%>
			<script>
				function set_req_amt(){
					var fm = document.form1;
					fm.req_amt.value 	= parseDecimal(toInt(parseDigit(fm.suit_amt.value)) + toInt(parseDigit(fm.loan_amt.value)));
				}	
			</script>
				 <td class=title width=9%>소송금액</td>
                 <td>&nbsp;수리비:&nbsp;<input type="text" name="suit_amt"  value="<%=AddUtil.parseDecimal(as_bean.getSuit_amt())%>" size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_req_amt()'>
                 <td>&nbsp;대차료:&nbsp;<input type="text" name="loan_amt"  value="<%=AddUtil.parseDecimal(as_bean.getLoan_amt())%>" size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_req_amt()'>
                 <td>&nbsp;총소송금액:&nbsp;<input type="text" name="req_amt"  value="<%=AddUtil.parseDecimal(as_bean.getReq_amt())%>" size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
				 </tr> 			
			 </table>
        </td>
    </tr>	    
	<tr><td class=h></td></tr>
    <tr><td class=line2 colspan=2></td></tr> 
       
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
           	    </tr>
                     <td class=title>접수일</td>
                     <td  >
                      &nbsp;<input type="text" name="suit_dt" value="<%=AddUtil.ChangeDate2(as_bean.getSuit_dt())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                     <td class=title>접수번호</td>
                     <td colspan="3"> 
                      &nbsp;<input type="text" name="suit_no" value="<%=as_bean.getSuit_no()%>" size="20" class=text  >
                    </td>
                   
                </tr>
            
               <tr> 
					 <td class=title>판결일</td>
                     <td>
                      &nbsp;<input type="text" name="mean_dt" value="<%=AddUtil.ChangeDate2(as_bean.getMean_dt())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title  width=9% >확정 과실비율</td>
                    <td >&nbsp;당사 
                      <input type="text" name="our_fault_per" value="<%=as_bean.getOur_fault_per()%>" size="4" class=num onBlur='javascript:document.form1.ot_fault_per.value=Math.abs(toInt(this.value)-100);'>
                      : 
                      <input type="text" name="ot_fault_per" value="<%=Math.abs(as_bean.getOur_fault_per()-100)%>" size="4" class=num onBlur='javascript:document.form1.our_fault_per.value=Math.abs(toInt(this.value)-100);'>
		                      상대방  
		            <td class=title  width=9% >정비비결재  비율</td>
                    <td>&nbsp;<input type="text" name="j_fault_per" value="<%=as_bean.getJ_fault_per()%>"   size="4" class=num >                      
                       <font  color=red> * 당사에서  정비공장에 결재해햐 하는 비율임. 사고유형 및 과실율과 무관할 수 있음.  </font>
                   </td>  
                </tr> 
                            
                <tr> 
                    <td class=title width=9%>입금일</td>
                    <td > 
                      &nbsp;<input type="text" name="pay_dt" value="<%=AddUtil.ChangeDate2(as_bean.getPay_dt())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>입금액</td>
                    <td colspan=3 >&nbsp; 
                     <input type="text" name="pay_amt" value="<%=AddUtil.parseDecimal(as_bean.getPay_amt())%>" size="11" class=num  onBlur='javascript:this.value=parseDecimal(this.value);'>
                   	 <a style="margin-left:120px;" href="javascript:send_msg('<%=c_id%>', '<%=accid_id%>', '<%=m_id%>', '<%=l_cd%>')"><img src="/acar/images/center/button_in_msg.gif" align="absmiddle" border="0"></a>
                    </td>
                </tr>    
                <tr> 
                    <td class=title width=9%>내용</td>
                    <td colspan="5" height="76"> 
                     &nbsp;<textarea name="suit_rem" cols="140" rows="3"><%=as_bean.getSuit_rem()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
       
    <tr></tr><tr></tr>
    
    <%if(from_page.equals("/fms2/settle_acc/fault_bad_complaint_frame.jsp")) {%>
    <tr>
        <td></td>
    </tr>
    <% if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){ %>
    <!-- 고객지원팀장 결재 취소 -->    
    <tr>
        <td align=center>
                결재요청취소사유 : <input type='text' name="sanction_req_cancel" value='' size="140" class='text'>
		<a href="javascript:sanction_req_cancel();" title='결제요청 취소하기'>[결제요청취소하기]</a>
        </td>
    </tr>
    <% } %>
    
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>소송 진행 결재</span></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=13% rowspan="2">결재</td>
                    <td class=title width=21%>기안자</td>					
                    <td class=title width=22%>고객지원팀장</td>
                    <td class=title width=22%>법무담당</td>
                    <td class=title width=22%>총무팀장</td> 
                </tr>
                              
                <tr>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><br><a href="javascript:doc_sanction('1');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if((doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)) && !doc.getDoc_step().equals("3") ){%><br><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%><%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%><%if((doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)) && !doc.getDoc_step().equals("3") ){%><br><a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;<a href="javascript:message_reg('9')">[고객팀장 메세지]</a><%}%><%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%><%if(!doc.getUser_dt3().equals("") && doc.getUser_dt4().equals("")){%><%if((doc.getUser_id4().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)) && !doc.getDoc_step().equals("3") ){%><br><a href="javascript:doc_sanction('4')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td> 
               	
	            </tr> 
                
            </table>
        </td>
    </tr>	
    
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>소송 결과 결재</span></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=13% rowspan="2">결재</td>
                    <td class=title width=43%>법무담당</td>
                    <td class=title width=44%>총무팀장</td>
                </tr>
                <tr>
  	              	<td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id5(),"USER_PO")%><br><%=doc.getUser_dt5()%><%if(!doc.getUser_dt4().equals("") && doc.getUser_dt5().equals("")){%><br><a href="javascript:doc_sanction('5');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id6(),"USER_PO")%><br><%=doc.getUser_dt6()%><%if(!doc.getUser_dt5().equals("") && doc.getUser_dt6().equals("")){%><%if(doc.getUser_id6().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%><br><a href="javascript:doc_sanction('6')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                  
                </tr>
            </table>
        </td>
    </tr>	
    <% } %>
       
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
