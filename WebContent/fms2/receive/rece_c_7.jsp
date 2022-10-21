<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.receive.*, acar.credit.*, acar.cls.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>

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
	
	String mode = request.getParameter("mode")==null?"5":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
		//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
		
	if(base.getUse_yn().equals("Y"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
				
	//해지정보
	ClsBean cls_info = ac_db.getClsCase(m_id, l_cd);
	
	Hashtable fee_base = re_db.getClsContInfo(m_id, l_cd);
	
	//rent_start_dt
	String  start_dt =  re_db.getRent_start_dt(l_cd);
	
	int  days =  c_db.getDays(  AddUtil.getDate(4), cls_info.getCls_dt());
	
	//추심정보
	ClsBandBean cls_band = re_db.getClsBandInfo(m_id, l_cd);
		
	//채권회수 및 수수료지급정보
	Vector vt_band = re_db.getClsBandEtcList(m_id, l_cd);
	int vt_band_size = vt_band.size();
		
	
	
	String ven_code = "";
	String ven_name = "";
	
	Vector cms_bnk = c_db.getCmsBank();	//은행명을 가져온다.
	int cms_bnk_size1 = cms_bnk.size();
	
	
	//동일채무자 타채권
	
	//해지정산 리스트
	Vector vt_ext = ac_db.getClsList(base.getClient_id());
	int vt_size = vt_ext.size();
	
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
	
	
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
	function save(cmd, st, no){
		var fm = document.form1;
		fm.cmd.value = cmd;
		fm.ioamt_st.value = st;
		fm.seq_no.value = no;
		if(cmd == 'd'){
			if(!confirm('삭제하시겠습니까?')){	return;	}
		}else{
			if(!confirm('등록하시겠습니까?')){	return;	}		
		}
		fm.action = "rece_c_7_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	
		//등록하기
	function  band_pay_reg()	{
		var SUBWIN="/fms2/receive/rece_c7_i.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&c_id=<%=c_id%>&rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>";	
		window.open(SUBWIN, "free_reg", "left=100, top=50, width=650, height=400, scrollbars=yes");
	}
	
	function  band_reg()	{
		var SUBWIN="/fms2/receive/receive_7_i.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&c_id=<%=c_id%>&rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>";	
		window.open(SUBWIN, "free_reg", "left=100, top=50, width=1000, height=500, scrollbars=yes");
	}

//-->
</script>
</head>
<body>

  <form action="rece_c_7_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
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
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='cmd' value='<%=cmd%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>  	


<table border='0' cellspacing='0' cellpadding='0' width='100%'>
         
  <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
        		  <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>위임내역</span></td>
 	 		 
 	 		  <td align="right">
<% if ( cls_band.getReq_dt().equals("") ) {%> 	 		  
 	 		  <a href='javascript:band_reg()'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
<% } %> 	 		  
 	 		  </td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
		                    <td width="13%" class=title>위임일자</td>
		                    <td colspan=6>&nbsp;<input type='text' name='req_dt' value='<%=AddUtil.ChangeDate2(cls_band.getReq_dt())%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 		           
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>위임업체명</td>
	                    <td colspan=4>&nbsp;
		            	<input name="n_ven_name" type="text" class="text" value="<%=cls_band.getN_ven_name()%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
						&nbsp;&nbsp;&nbsp;* 네오엠코드 : &nbsp;	        
				<input type="text" readonly name="n_ven_code" value="<%=cls_band.getN_ven_code()%>" class='whitetext' >
			      	<input type="hidden" name="n_ven_nm_cd"  value="">&nbsp;		
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> </td>				
		
	                    <td width="13%" class='title'>추심수수료(vat별도)</td>
	                    <td>&nbsp;회수금액의 <input type="text" name="re_rate" value="<%=cls_band.getRe_rate()%>" size="3" class=num>%</td>	             
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>부서명</td>
	                    <td width="20%">&nbsp;<input type="text" name="re_dept" value="<%=cls_band.getRe_dept()%>" size="25" class=text></td>
	                    <td width="10%" class='title' rowspan=2>담당자</td>
	                    <td width="10%" class='title'>성명</td>
	                    <td><input type="text" name="re_nm" value="<%=cls_band.getRe_nm()%>" size="25" class=text></td>	             
	                   <td width="13%" class='title'>fax</td>
	                    <td><input type="text" name="re_fax" value="<%=cls_band.getRe_fax()%>" size="25" class=text></td>	             
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>대표전화</td>
	                    <td width="20%">&nbsp;<input type="text" name="re_tel" value="<%=cls_band.getRe_tel()%>" size="25" class=text></td>	            
	                    <td width="10%" class='title'>연락처</td>
	                    <td><input type="text" name="re_phone" value="<%=cls_band.getRe_phone()%>" size="25" class=text></td>	             
	                   <td width="13%" class='title'>이메일</td>
	                    <td><input type="text" name="re_mail" value="<%=cls_band.getRe_mail()%>" size="25" class=text style='IME-MODE: inactive'></td>	             
	                </tr>     
	            
		       </table>
		      </td>        
         </tr>   
               
     	</table>
      </td>	 
    </tr>	 
        
    <tr></tr><tr></tr>
        <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래계좌</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
		                    <td width="50%" class=title colspan=3>채권회수금 입금계좌</td>
		                    <td width="50%" class=title colspan=3>추심수수료 지급계좌</td>		                
	                </tr>
	                 <tr>
	                    <td width="15%" class=title>은행명</td>
	                     <td width="15%" class=title>예금주</td>
	                     <td width="20%" class=title>계좌번호</td>
	                      <td width="15%" class=title>은행명</td>
	                      <td width="15%" class=title>예금주</td>
	                      <td width="20%" class=title>계좌번호</td>	            
	                </tr>
	                   <tr>
	                      <td >&nbsp; <select name="bank_cd" style="width:135">
                            <option value="">==선택==</option>                         
			     	 <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
						 <option value='<%=h_c_bnk.get("BCODE")%>' <%if(cls_band.getBank_cd().equals((String)h_c_bnk.get("BCODE"))){%>selected<%}%>><%= h_c_bnk.get("BNAME")%></option>
				                     
				              <%		}
							}%>
			      </select></td>	   	           
	                     <td width="15%">&nbsp;<input type="text" name="bank_nm" value="<%=cls_band.getBank_nm()%>" size="25" class=text></td>
	                     <td width="20%">&nbsp;<input type="text" name="bank_no" value="<%=cls_band.getBank_no()%>" size="25" class=text></td>
	                    <td >&nbsp; <select name="re_bank_cd" style="width:135">
                            <option value="">==선택==</option>                         
			     	 <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					     <option value='<%=h_c_bnk.get("BCODE")%>' <%if(cls_band.getRe_bank_cd().equals((String)h_c_bnk.get("BCODE"))){%>selected<%}%>><%= h_c_bnk.get("BNAME")%></option>
                     
				              <%		}
							}%>
			      </select></td>	             
	                      <td width="15%">&nbsp;<input type="text" name="re_bank_nm" value="<%=cls_band.getRe_bank_nm()%>" size="25" class=text></td>
	                      <td width="20%">&nbsp;<input type="text" name="re_bank_no" value="<%=cls_band.getRe_bank_no()%>" size="25" class=text></td>	            
	                </tr>         
	              
		       </table>
		      </td>        
         </tr>   
          <tr></tr><tr></tr>
          <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>위임채권의 내용</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
		                     <td width="8%" class=title rowspan=3>채권</td>
		                     <td width="10%" class=title >금전채권</td>
		                     <td colspan=3 >&nbsp;<input type="text" name="band_amt" value="<%=AddUtil.parseDecimal(cls_band.getBand_amt())%>" size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>
		                     <td width="10%" class=title >기준일자</td>		                
		                     <td width="10%" ><input type="text" name="basic_dt" value="<%=AddUtil.ChangeDate2(cls_band.getBasic_dt())%>" size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 	       
	                  </tr>
	                	 <tr>
		                     <td width="10%" class=title >미회수자동차</td>
		                     <td width="12%">&nbsp;<input type="text" name="no_re_amt" value="<%=AddUtil.parseDecimal(cls_band.getNo_re_amt())%>" size="20" class=num></td>
		                     <td width="10%" class=title >잔가</td>		                
		                     <td width="10%" ><input type="text" name="car_jan_amt" value="<%=AddUtil.parseDecimal(cls_band.getCar_jan_amt())%>" size="15" class=num></td>	
		                     <td width="10%" class=title >잔가산정기준/일자</td>	
		                     <td width="10%" >&nbsp;</td>		                
	                  </tr>
	                   <tr>
		                     <td width="10%" class=title >합계</td>
		                     <td width="12%">&nbsp;<input type="text" name="tot_amt" value="<%=AddUtil.parseDecimal(cls_band.getBand_amt()+cls_band.getNo_re_amt())%>" readonly size="20" class=num></td>
		                     <td width="13%" class=title >미회수자동차의위임구분</td>		                
		                     <td width="13%" >&nbsp;<input type="radio" name="re_st" value="1"  <%if(cls_band.getRe_st().equals("1"))%>checked<%%>>통합위임
	                            <input type="radio" name="re_st" value="2" <%if(cls_band.getRe_st().equals("2"))%>checked<%%>>개별</td>	              
		                     <td  colspan=2>&nbsp;합계=금전채권+미회수자동차의 잔가</td>		                
	                  </tr>
	                    <tr>
		                     <td width="13%" class=title  colspan=2 >동일채무자 타채권</td>
		                     <td width="12%" align=right ><%=vt_size - 1%>건</td>
		                     <td colspan=2>&nbsp;</td>		                
		                     <td width="10%" class=title >총채권금액</td>	
		                     <td width="10%">&nbsp;</td>		                
	                  </tr>
	               
	              
		       </table>
		      </td>        
         </tr>   
           
     	 <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	     	 	    
  
        <tr></tr><tr></tr>
          <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채권회수 및 수수료지급</span></td>
 	 		 <td align="right"><a href='javascript:band_pay_reg()'><img src=/acar/images/center/button_plus.gif border=0 align=absmiddle></a></td>
 	 	  </tr>
 	 	  <tr>
      		 <td colspan=2 class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	<td colspan=2  class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
		                     <td width="8%" class=title rowspan=2>연번</td>
		                     <td width="46%" class=title colspan=3 >입금(회수금액)</td>
		                     <td width="46%" class=title colspan=3 >지급(추심수수료)</td>		                
	                  </tr>
	                	 <tr>
		                     <td width="15%" class=title >구분</td>	
		                     <td width="15%" class=title >금액</td>			                   
		                     <td width="16%" class=title >입금일자</td>		                
		           	   <td width="15%" class=title >구분</td>	
		                     <td width="15%" class=title >금액</td>			                   
		                     <td width="16%" class=title >지급일자</td>			                                    
	                  </tr>	       
 <%		for(int i = 0 ; i < vt_band_size ; i++)
		{
			Hashtable ht = (Hashtable)vt_band.elementAt(i);
%>
				<tr>
					<td  width='8%' align='center'><%=i+1%></td>		
					<td  width='15%' align='center'><%=ht.get("BAND_ST")%></td>		
					<td  width='15%' align='right'><%=AddUtil.parseDecimal(ht.get("DRAW_AMT"))%></td>
					<td  width='16%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BAND_IP_DT")))%></td>
					<td  width='15%'  align='center'>&nbsp지급수수료</td>			
					<td  width='15%' align='right'><%=AddUtil.parseDecimal(ht.get("RATE_AMT"))%></td>
					<td  width='16%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RATE_JP_DT")))%></td>	
				</tr>

<%  } %>			                  
	   	                                      
		       </table>
		      </td>        
         		</tr>              		
           		
     	 	<tr>
     		 <td>&nbsp;</td>
     		 </tr>
     	</table>
      </td>	 
    </tr>	  	 	     	 	    
        

  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>

</script>
</body>
</html>
