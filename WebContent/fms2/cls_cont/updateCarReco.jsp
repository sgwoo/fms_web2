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

	//차량회수정보
	CarRecoBean carReco = ac_db.getCarReco(rent_mng_id, rent_l_cd);
	
		//연대보증인 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	  CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;          

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
<form name='form1' action='updateCarReco_a.jsp' method='post'>
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
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량회수&nbsp;</span></td>
		    </tr>
		    <tr>
		        <td class=line2></td>
		    </tr>
		    
		    <tr>
		        <td class=line>
		            <table width=100%  border=0 cellspacing=1 cellpadding=0>
		             <tr> 
			            <td width='13%' class='title'>회수여부</td>
			            <td width="20%">&nbsp;<input type="radio" name="reco_st" value="Y"  <%if(carReco.getReco_st().equals("Y"))%>checked<%%> >회수
	                            <input type="radio" name="reco_st" value="N" <%if(carReco.getReco_st().equals("N"))%>checked<%%> >미회수</td>
	                    <td width='13%' class='title'>구분</td>
	                    
	                    <td id=td_ret1 style="display:<%if( carReco.getReco_st().equals("Y") ){%>''<%}else{%>none<%}%>"> &nbsp; 
						  <select name="reco_d1_st"  >
						    <option value="1" <%if(carReco.getReco_d1_st().equals("정상회수"))%>selected<%%>>정상회수</option>
						    <option value="2" <%if(carReco.getReco_d1_st().equals("강제회수"))%>selected<%%>>강제회수</option>
						    <option value="3" <%if(carReco.getReco_d1_st().equals("협의회수"))%>selected<%%>>협의회수</option>
			               </select>       
			            </td>
			            
			            <td id=td_ret2 style="display:<%if( carReco.getReco_st().equals("N") ){%>''<%}else{%>none<%}%>"> &nbsp; 
						  <select name="reco_d2_st"  >
						    <option value="1" <%if(carReco.getReco_d2_st().equals("도난"))%>selected<%%>>도난</option>
						    <option value="2" <%if(carReco.getReco_d2_st().equals("횡령"))%>selected<%%>>횡령</option>
						    <option value="3" <%if(carReco.getReco_d2_st().equals("멸실"))%>selected<%%>>멸실</option>						  
						   </select>       
			            </td>
			            
			            <td class='title' width='13%' >사유</td>
						<td>&nbsp;
						<input type="text" name="reco_cau" value='<%=carReco.getReco_cau()%>'size=30 maxlength=100 readonly >
						</td>				        		         
		         </tr>
		                 <tr>      
		            <td width='10%' class='title'>회수일자</td>
		            <td>&nbsp;
					  <input type='text' name='reco_dt'  value='<%=carReco.getReco_dt()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		            <td width='10%' class='title'>회수담당자</td>
		            <td>&nbsp;
					  <select name='reco_id' disabled >
		                <option value="">선택</option>
		                  <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                 <option value='<%=user.get("USER_ID")%>' <%if(carReco.getReco_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
		                 <%		}
						 	}%>							           
		              </select>
		            </td>
		            <td width='10%' class='title'>입고일자</td>
		            <td>&nbsp;
					  <input type='text' name='ip_dt'  size='12' value='<%=carReco.getIp_dt()%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		          </tr>
		         
		  <tr>          
		            <td class=title>차량현위치</td>
	                <td colspan=5> 
	                      &nbsp;<SELECT NAME="park" >
				                 <option value="" <% if(carReco.getPark().equals("")){%>selected<%}%>>--선택--</option>				                 
				                    <%if(good_size > 0){ 			
	                   			   for(int i = 0 ; i < good_size ; i++){
                  								CodeBean good = goods[i];%>
		       		          <option value='<%= good.getNm_cd()%>' <% if(carReco.getPark().equals(good.getNm_cd() ) )  {%>selected<%}%>><%= good.getNm()%></option>
		                 <%		}
						 	}%>						
	        		        </SELECT>
							<input type="text" name="park_cont" value='<%=carReco.getPark_cont()%>'  size="80" class=text style='IME-MODE: active'>
							(기타선택시 내용)
	                    </td>
	            </tr>
	            <tr>        
	                       <td class=title>예비차 사용가능</td>
                    	    <td >&nbsp;<input type="radio" name="serv_st" value="Y"  <%if(cls.getServ_st().equals("Y"))%>checked<%%> >즉시가능
	                            <input type="radio" name="serv_st" value="N" <%if(cls.getServ_st().equals("N"))%>checked<%%> >수리후 가능</td>	             
	                        <td class=title>예비차 적용</td>
                    	    <td colspan=3>&nbsp;<input type="radio" name="serv_gubun" value="1"  <%if(cls.getServ_gubun().equals("1"))%>checked<%%> >재리스/월렌트
	                            &nbsp;<input type="radio" name="serv_gubun" value="3" <%if(cls.getServ_gubun().equals("3"))%>checked<%%> >월렌트
	                            &nbsp;<input type="radio" name="serv_gubun" value="2" <%if(cls.getServ_gubun().equals("2"))%>checked<%%> >매각</td>                        		          	          
		          </tr>		          
		          <tr>      
		            <td width='10%' class='title'>외주비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='12'  value='<%=AddUtil.parseDecimal(carReco.getEtc_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
		            </td>
		            <td width='10%' class='title'>부대비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='12'   value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
		            </td>
		            <td width='10%' class='title'>비용계</td>
		            <td>&nbsp;
					 <input type='text' name='etc_out_amt' size='12'  value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt() + carReco.getEtc_d1_amt())%>' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
		            </td>
		          </tr>
		             	                		      
		    	</table>
		  		</td>
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
