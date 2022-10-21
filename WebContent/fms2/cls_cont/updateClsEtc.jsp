<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String rent_st  	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cmd	  		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String c_st = "";
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
		//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
			//담당자 리스트
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
	
	
	
	
	
	
	//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st();
	
	//해지의뢰상계정보
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);

	//채권관리정보
	CarCreditBean carCre = ac_db.getCarCredit(rent_mng_id, rent_l_cd);	
	
		//연대보증인 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	Vector cms_bnk = c_db.getCmsBank();	//은행명을 가져온다.
	int cms_bnk_size1 = cms_bnk.size();		
	
		//해지기타 추가 정보
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		fm = document.form1;
					
		if(!confirm("변경하시겠습니까?"))	return;
		//fm.target = "i_no";
		fm.submit();
	}

//-->
</script>
</head>

<body>
<center>
<form name='form1' action='updateClsEtc_a.jsp' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='20%'>계약번호</td>
                    <td width='20%' align="center"><%=rent_l_cd%></td>
    			    <td class='title' width='15%'>상호</td>
                    <td width='45%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title' width='20%'>차량번호</td>
                    <td width='20%' align="center"><%=cr_bean.getCar_no()%></td>
    			    <td class='title' width='15%'>차명</td>
                    <td width='45%'>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr> 
        <td align="right"></td>
    </tr>

	<tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
	
		<tr> 
	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지내역&nbsp;</span></td>
	    </tr> 	
		<tr>
	        <td class=line2></td>
	    </tr>
	    <tr> 
	      <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <tr> 
	            <td width='13%' class='title'>해지구분</td>
	            <td width="13%">&nbsp; 
				  <select name="cls_st"  >
				    <option value="1" <%if(cls.getCls_st().equals("계약만료"))%>selected<%%>>계약만료</option>
				    <option value="7" <%if(cls.getCls_st().equals("출고전해지(신차)"))%>selected<%%>>출고전해지(신차)</option>
	                <option value="8" <%if(cls.getCls_st().equals("매입옵션"))%>selected<%%>>매입옵션</option>
	                <option value="2" <%if(cls.getCls_st().equals("중도해약"))%>selected<%%>>중도해약</option>
	                <option value="10" <%if(cls.getCls_st().equals("개시전해지(재리스)"))%>selected<%%>>개시전해지(재리스)</option>
	                <option value="14" <%if(cls.getCls_st().equals("월렌트해지"))%>selected<%%>>월렌트해지</option>
			      </select> </td>
	                      					  
	            <td width='13%' class='title'>의뢰자</td>
	            <td width="12%">&nbsp;
	              <select name='reg_id'  >
	                <option value="">선택</option>
	                <%	if(user_size > 0){
							for(int i = 0 ; i < user_size ; i++){
								Hashtable user = (Hashtable)users.elementAt(i); %>
	                <option value='<%=user.get("USER_ID")%>' <%if(cls.getReg_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
	                <%		}
						}%>
	              </select></td>	
	                      
	            <td width='13%' class='title'>해지일자</td>
	            <td width="12%">&nbsp;
				  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt())%>'  size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 
			    <td width='13%' class='title'>이용기간</td>
			    <td >&nbsp;
			       <input type='text' name='r_mon' class='text' size='2' value='<%=cls.getR_mon()%>'  >개월&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=cls.getR_day()%>'  >일&nbsp;</td>
	          </tr>
	          
	          <tr> 
	            <td class='title'>사유 </td>
	            <td colspan="5">&nbsp;
	              <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cls.getCls_cau()%></textarea>				
	            </td>
	             <td width="12%" class=title >만기매칭<br>대차여부</td>
                      <td>&nbsp; 
		       <select name="match" >
		           <option value="" <% if(cls.getMatch().equals("")){%>selected<%}%>>--선택--</option>
                              <option value="Y" <% if(cls.getMatch().equals("Y")){%>selected<%}%>>만기매칭</option>           
                          </select>
                      </td>
	          </tr>
	          <tr>                                                      
	            <td class=title >잔여선납금<br>매출취소여부</td>
	     	    <td>&nbsp; 
				  <select name="cancel_yn" onChange='javascript:cancel_display()' disabled >
	                <option value="N" <% if(cls.getCancel_yn().equals("N")){%>selected<%}%>>매출유지</option>
	                <option value="Y" <% if(cls.getCancel_yn().equals("Y")){%>selected<%}%>>매출취소</option>
	              </select>
			    </td>
	            <td  colspan="6" align=left>&nbsp;※ 기발행 계산서의 유지 또는 취소여부 등 확인이 필요, 매출취소시 마이너스 세금계산서 발행 </td>
	          </tr>
	                
	        </table>
	      </td>
	    </tr>
	    
	    <tr></tr><tr></tr><tr></tr>
	    <tr> 
	         <td class="line">
	                <table width="100%" border="0" cellspacing="1" cellpadding="0">
	                    <tr> 
	                        <td class="title" width=12% >주행거리</td>
	                        <td width=13% >&nbsp; <input type='text' name='tot_dist' size='10' value='<%=AddUtil.parseDecimal(cls.getTot_dist())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km </td>
	                        <td  colspan="4" align=left>&nbsp;※ 중도해지 및 만기시 차량주행거리 </td>
	                    </tr>                 
	                                  
	                </table>
	          </td>
	   </tr> 
		          
	   <tr></tr><tr></tr><tr></tr>
	   <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	       		  <tr>
	                    <td class=title width=10%>연체료감액<br>결재자</td>
	                    <td width=12%>&nbsp;
							   <select name='dly_saction_id'>
				                <option value="">--선택--</option>
				                 <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
				                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getDly_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>				                 <%		}
								 	}%>		              
				              </select>
				        </td>
	                    <td class=title width=12%>연체료 감액사유</td>
	                    <td colspan=3>&nbsp;<textarea name="dly_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getDly_reason()%></textarea></td> 
					 
	                </tr>
	                <tr>
	                	<td class=title width=10%>중도해지위약금<br>감액 결재자</td>
	                    <td width=12%>&nbsp;
							   <select name='dft_saction_id'>
				                <option value="">--선택--</option>
				                 <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
				                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getDft_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
				                 <%		}
								 	}%>		              
				              </select>
				        </td>
	                    <td class=title width=12%>중도해지위약금<br>감액사유</td>
					    <td colspan=3>&nbsp;<textarea name="dft_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getDft_reason()%></textarea></td> 
					    
	                </tr>
	                <tr> 
	                  	<td class=title width=10%>확정금액결재자</td>
	                    <td width=12%>&nbsp;
							   <select name='d_saction_id'>
				                <option value="">--선택--</option>
				                 <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
				                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getD_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
				                 <%		}
								 	}%>		              
				              </select>
				        </td>
	                    <td class=title width=12%>확정금액 사유</td>
	                    <td colspan=3>&nbsp;<textarea name="d_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getD_reason()%></textarea></td> 					   
	                </tr>
					    <tr> 
	                  	<td class=title width=10%>선수금후불처리결재자</td>
	                    <td width=12%>&nbsp;
							   <select name='ext_saction_id'>
				                <option value="">--선택--</option>
				                 <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
				                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getExt_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
				                 <%		}
								 	}%>		              
				              </select>
				        </td>
	                    <td class=title width=12%>확정금액 사유</td>
	                    <td colspan=3>&nbsp;<textarea name="ext_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getExt_reason()%></textarea></td> 
					   
	                </tr>
	                </table>
	         </td>       
   		 </tr>       
	     <tr></tr><tr></tr><tr></tr>
		 <tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>              
					                    <td class=title style='height:44' width=13%>처리의견/지시사항/사유</td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="remark" cols="140" class="text" style="IME-MODE: active" rows="3"><%=cls.getRemark()%></textarea> 
					                    </td>
					                </tr>
		                
		           				</table>
		           			</td>
		           		</tr>
		           	</table>			
		        </td>
		    </tr>
	    
    	</table>
      </td>	 
    </tr>	
    
      <tr></tr><tr></tr><tr></tr>
	<tr> 
	       <td class="line">
	               <table width="100%" border="0" cellspacing="1" cellpadding="0">
	                    <tr> 
	                        <td class="title" width=12% >영업효율대상자</td>
	                        <td width="13%">&nbsp; 
							  <select name="dft_cost_id"  >
							       <option value="">--선택--</option>
				                 <%	if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
				                 <option value='<%=user.get("USER_ID")%>' <%if(cls.getDft_cost_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
				                 <%		}
								 	}%>		              
				              </select>				              
				
			                </td>	                      
	                        <td  colspan="4" align=left>&nbsp;※ 영업효율대상자를 잘못 입력시 변경하세요.  </td>
	                    </tr>                 
	                                  
	                </table>
	       </td>
	</tr> 
	
    
    <tr></tr><tr></tr><tr></tr>
	<tr> 
	       <td class="line">
	               <table width="100%" border="0" cellspacing="1" cellpadding="0">
	                    <tr> 
	                        <td class="title" width=12% >CMS인출의뢰</td>
	                        <td width="13%">&nbsp; 
							  <select name="cms_chk"  >
							    <option value="" <%if(cls.getCms_chk().equals(""))%>selected<%%>>선택</option>
				                <option value="Y" <%if(cls.getCms_chk().equals("Y"))%>selected<%%>>CMS의뢰</option>
				                <option value="N" <%if(cls.getCms_chk().equals("N"))%>selected<%%>>CMS미의뢰</option>				           
						      </select>
			                </td>	                      
	                      <td  colspan="3" align=left>&nbsp;※ 중도해지정산금을 CMS로 인출하고자할 경우는 CMS인출의뢰에 check 하세요. </td>
	                      <td><input type='checkbox' name='cms_after' value='Y' <%if(clsm.getCms_after().equals("Y")){%>checked<%}%> ><font color="red">CMS 확인후 익일처리</font></td>
	                    </tr>                 
	                                  
	                </table>
	       </td>
	</tr> 
		   
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_refund style="display:<%if( cls.getFdft_amt2() < 0 && !cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                    <tr> 
                        <td class="title" width=13% >예금주명</td>
                        <td >&nbsp; <input type="text" name="re_acc_nm" value='<%=cls.getRe_acc_nm()%>' size="30" class=text></td>
                        <td width=13% class="title">은행명</td>
                        <td >&nbsp; <select name="re_bank" style="width:135">
                            <option value="">==선택==</option>                         
			     	 <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					    	<option value='<%=h_c_bnk.get("BCODE")%>'  <%if(cls.getRe_bank().equals((String)h_c_bnk.get("BCODE"))){%>selected<%}%>><%= h_c_bnk.get("BNAME")%></option> > 	
                     
				              <%		}
							}%>
				              </select></td>
                        <td width=13% class="title">계좌번호</td>
                        <td >&nbsp; <input type="text" name="re_acc_no" value='<%=cls.getRe_acc_no()%>' size="30" class=text></td>
                    </tr>                 
                                  
                </table>
            </td>
    </tr>               	 	
         
    <tr> 
        <td align="right">
        
            <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%}%>
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
	
</table>

</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
