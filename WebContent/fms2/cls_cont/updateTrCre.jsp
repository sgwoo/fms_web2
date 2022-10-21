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
<form name='form1' action='updateTrCre_a.jsp' method='post'>
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
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채권관계</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr>
                    <td class=title width=12%>보증보험</td>
                    <td class=title width=13%>보험금액</td>
                    <td width=12%>&nbsp;<input type='text' name='gi_amt' readonly value='<%=AddUtil.parseDecimal(carCre.getGi_amt())%>' size='15' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                    <td class=title width=12%>청구채권</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_c_amt' size='15' value='<%=AddUtil.parseDecimal(carCre.getGi_c_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'> 원</td>
                    <td class=title width=12%>잔존채권</td>
                    <td width=13%>&nbsp;<input type='text' name='gi_j_amt' size='15' value='<%=AddUtil.parseDecimal(carCre.getGi_j_amt())%>' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
                </tr>
                <!-- 대표연대보증등 -->
<% if(gur_size > 0){
				for(int i = 0 ; i < gur_size ; i++){
					Hashtable gur = (Hashtable)gurs.elementAt(i); %>       
				                
                <tr>
                  <%if (i == 0 ) { %> <td class=title width=12% rowspan=<%=gur_size%>>연대보증</td> <% } %>
                    <td class=title width=13%>입보구분</td>
                    <td width=12%>&nbsp;<input type='text' name='gu_st'  size='15' class='text' > </td>
                    <td class=title width=12%>보증인성명</td>
                    <td width=13%>&nbsp;<input type='text' name='gu_nm' value='<%=gur.get("GUR_NM")%>' size='15' class='text' > </td>
                    <td class=title width=12%>계약자와관계</td>
                    <td width=13%>&nbsp;<input type='text' name='gu_rel' value='<%=gur.get("GUR_REL")%>' size='15' class='text' ></td>
                </tr>
             <% }
  }             %> 
                <tr>
                    <td class=title width=12%>자동차손해보험</td>
                    <td class=title width=13%>보험사</td>
                    <td width=12%>&nbsp;<input type='text' name='c_ins' value='<%=carCre.getC_ins()%>'  size='18' class='text' > </td>
                    <td class=title width=12%>담당자</td>
                    <td width=13%>&nbsp;<input type='text' name='c_ins_d_nm'  value='<%=carCre.getC_ins_d_nm()%>' size='18' class='text' > </td>
                    <td class=title width=12%>연락처</td>
                    <td width=13%>&nbsp;<input type='text' name='c_ins_tel' value='<%=carCre.getC_ins_tel()%>' size='18' class='text' ></td>
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
        
    <tr> 
    
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>잔존채권의 처리의견/지시사항&nbsp;</span></td>
 	 	  </tr>  
	      <tr>
	        <td class=line2></td>
	      </tr>
	      <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	                <tr>
	                    <td class=title colspan=2>구분</td>
	                    <td class=title width=80%>처리의견/지시사항/사유</td>
	                  
	                </tr>
	                <tr>
	                    <td class=title width=12%>보증보험청구</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu1">
	                          <option value="" selected>-선택-</option>
	                          <option value="Y" <% if(carCre.getCrd_reg_gu1().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu1().equals("N")){%>selected<%}%>>아니오</option>
		                   </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark1' value='<%=carCre.getCrd_remark1()%>' size='120' class='text' ></td>
	                 
	                </tr>
	                <tr>
	                    <td class=title>연대보증인구상</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu2">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu2().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu2().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark2' value='<%=carCre.getCrd_remark2()%>' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>채권추심외주</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu3">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu3().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu3().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark3' value='<%=carCre.getCrd_remark3()%>' size='120' class='text' ></td>
	                   
	                </tr>
	                <tr>
	                    <td class=title>자동차손해보험</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu4">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu4().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu4().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark4' value='<%=carCre.getCrd_remark4()%>' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>면제</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu5">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu5().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu5().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark5' value='<%=carCre.getCrd_remark5()%>' size='120' class='text' ></td>
	                  
	                </tr>
	                <tr>
	                    <td class=title>대손처리</td>
	                    <td width=13% align=center> 
	                       <select name="crd_reg_gu6">
	                          <option value="" selected>-선택-</option>
		                      <option value="Y" <% if(carCre.getCrd_reg_gu6().equals("Y")){%>selected<%}%>>예</option>
                  			  <option value="N" <% if(carCre.getCrd_reg_gu6().equals("N")){%>selected<%}%>>아니오</option>
	                        </select>      
	                    </td>
	                    <td>&nbsp;<input type='text' name='crd_remark6'  value='<%=carCre.getCrd_remark6()%>' size='120' class='text' ></td>
	                  
	                </tr>
	            </table>
	        </td>
	      </tr>
	     <tr></tr><tr></tr>     
	      <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	       		  <tr>
	                    <td class=title width=12%>결재자</td>
	                    <td width=12%>&nbsp;
							  <select name='crd_id'>
				                <option value="">선택</option>
				                 <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
			                   <option value='<%=user.get("USER_ID")%>' <%if(carCre.getCrd_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
			                 <%		}
							 	}%>	
				              </select>
				        </td>
	                    <td class=title width=12%>사유</td>
					    <td colspan=3>&nbsp;<input type='text' name='crd_reason' value='<%=carCre.getCrd_reason()%>' size='100' maxlength=300 class='text'></td>
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
  
    <tr> 
        <td align="right"><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
	
</table>

</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
