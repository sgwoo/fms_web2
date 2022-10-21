<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.car_register.*, acar.client.*, acar.cont.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %> 

<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	int    seq	 	= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//탁송의뢰 1번
	ConsignmentBean cons = cs_db.getConsignment(cons_no, seq);
	
	CarRegBean 		car 		= crd.getCarRegBean(cons.getCar_mng_id());
	ContCarBean 	car_etc 	= a_db.getContCarNew(cons.getRent_mng_id(), cons.getRent_l_cd());
	ClientBean 		client 		= al_db.getNewClient(cons.getClient_id());
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
	
	//의뢰자
	UsersBean sender_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	Vector  codes2 = new Vector();
	int c_size2 = 0;	

	codes2 = c_db.getCodeAllV_0022_all("0022");	
	c_size2= codes2.size();
	
	
	String white = "";
	String disabled = "";
	white = "white";
	disabled = "disabled";
	int j = seq;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
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
<input type='hidden' name='cons_no' value='<%=cons_no%>'>
<input type='hidden' name='off_id' value='<%=cons.getOff_id()%>'>
<input type='hidden' name='off_nm' value='<%=cons.getOff_nm()%>'>
<input type='hidden' name='reg_code' value='<%=cons.getReg_code()%>'>
<input type='hidden' name='req_id' value='<%=doc.getUser_id1()%>'>
<input type='hidden' name="doc_no" 	value="<%=doc.getDoc_no()%>">  
<input type='hidden' name="doc_bit" value="">
<input type='hidden' name="mode" value="">
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 탁송관리 > <span class=style5>탁송의뢰서</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    	
  
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>		
    <tr id=tr_cons<%=j%>_2 style="display:''"> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        	<tr><td class=line2></td></tr>
		  <tr>
		    <td width='13%' class='title'>탁송번호</td>
			<td>&nbsp;
			  <%=cons_no%></td>
		    <td width='13%' class='title'>탁송업체</td>
			<td>&nbsp;
			  <%=cons.getOff_nm()%></td>
		  </tr>
          <tr> 
            <td width='13%' class='title'>차량번호</td>
            <%
            	String prev_car_no = cons.getCar_no();
            	String car_no = "";
            	
            	if( prev_car_no.length() > 10 ){
            		car_no = cs_db.getCarNo(cons_no, seq);
            	}
            	car_no = car_no == "" ? prev_car_no : car_no;
            	
            %>
            <td width='37%'>&nbsp;<%=cons.getCar_no()%>
			  <input type='hidden' name="car_no" value='<%=cons.getCar_no()%>' size='15' class='<%=white%>text' readonly>
			  <input type='hidden' name='seq' value='<%=cons.getSeq()%>'>
			  <input type='hidden' name='car_mng_id' value='<%=cons.getCar_mng_id()%>'>
			  <input type='hidden' name='rent_mng_id' value='<%=cons.getRent_mng_id()%>'>
			  <input type='hidden' name='rent_l_cd' value='<%=cons.getRent_l_cd()%>'>
			  <input type='hidden' name='client_id' value='<%=cons.getClient_id()%>'>
			  <%if(white.equals("")){%>
			  <!--<span class="b"><a href='javascript:search_car(<%=j%>)' onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>-->
			  <%}%>
			</td>
			<td width='13%' class='title'>차명</td>
			<td width='37%'>&nbsp;<%=car.getCar_nm()%>
			  <input type='hidden' name="car_nm" value='<%=car.getCar_nm()%>' size='40' class='whitetext' readonly></td>
          </tr>
		  <tr>
		    <td class='title'>연식</td>
			<td>&nbsp;<%=car.getCar_y_form()%>
			  <input type='hidden' name="car_y_form" value='<%=car.getCar_y_form()%>' size='40' class='whitetext' readonly>
			</td>
		    <td class='title'>색상</td>
			<td>&nbsp;<%=car_etc.getColo()%>
			  <input type='hidden' name="color" value='<%=car_etc.getColo()%>' size='40' class='whitetext' readonly></td>			
		  </tr>
		</table>
	  </td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>		
    <tr> 
      <td class='line'> 		
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
        	<tr><td class=line2></td></tr>
          <tr>
            <td class=title width=13% rowspan="2">결재</td>
            <td class=title width=15%>지점명</td>
            <td class=title width=11%>의뢰</td>
            <td class=title width=11%>수신</td>
            <td class=title width=13%>정산</td>
            <td class=title width=12%>청구</td>
            <td class=title width=12%>결재</td>
            <td class=title width=13%>지급</td>
          </tr>
          <tr>
            <td align="center"><%=sender_bean.getBr_nm()%></td>
            <td align="center"><%=sender_bean.getUser_nm()%><br><%=doc.getUser_dt1()%></td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>&nbsp;</td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>&nbsp;</td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%>&nbsp;</td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id5(),"USER_PO")%><br><%=doc.getUser_dt5()%>&nbsp;</td>
            <td align="center"><%=c_db.getNameById(doc.getUser_id6(),"USER_PO")%><br><%=doc.getUser_dt6()%>&nbsp;</td>
          </tr>
        </table>
	  </td>
    </tr>
	<tr id=tr_cons<%=j%>_3 style="display:''">
	  <td align="right">&nbsp;</td>
	</tr>	
    <tr id=tr_cons<%=j%>_4 style="display:''"> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>		  
    		    <tr>
        		    <th width=13% colspan="2">담당자</td>
        		    <td width=18%>&nbsp;
					<%if(cons.getReq_id().equals("")) cons.setReq_id(doc.getUser_id1());%>
        			  <select name='req_id' <%=disabled%>>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cons.getReq_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
        		    <th width=13%>탁송구간</td>
        		    <td width="*">&nbsp;
        			  <select name="cmp_app" <%=disabled%>>
        			    <option value="">선택</option>
        			    	<%for(int i = 0 ; i < c_size2 ; i++){
        					Hashtable code2 = (Hashtable)codes2.elementAt(i);%>
        					<option value='<%=code2.get("NM_CD")%>' <%if(cons.getCmp_app().equals(String.valueOf(code2.get("NM_CD") ))){%>selected<%}%>><%=code2.get("NM")%></option>
        				<%}%>   				
        				
          			  </select>
        			  <!--(자체탁송일때)-->
        			</td>					
    	        </tr>		        
		  <tr>
		    <td colspan="2" class='title'>탁송사유</td>
		    <td colspan="3">&nbsp;
			  <select name="cons_cau" onChange="javascript:cng_input4(this.value, <%=j%>)" <%=disabled%>>
			    <option value="">선택</option>
				<%for(int i = 0 ; i < c_size ; i++){
					CodeBean code = codes[i];	%>
				<option value='<%=code.getNm_cd()%>' <%if(cons.getCons_cau().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
				<%}%>
  			  </select>
			  <%if(!cons.getCons_cau_etc().equals("")){%>&nbsp;기타사유 : <%=cons.getCons_cau_etc()%><%}%>
			  <input type='hidden' name="cons_cau_etc" value='<%=cons.getCons_cau_etc()%>' size='40' class='<%=white%>text'>
			</td>
	      </tr>
		  <tr>
		    <td colspan="2" class='title'>비용구분</td>
			<td width="37%">&nbsp;
			  <select name="cost_st" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="1" <%if(cons.getCost_st().equals("1")){%>selected<%}%>>아마존카</option>
			    <option value="2" <%if(cons.getCost_st().equals("2")){%>selected<%}%>>고객</option>								
  			  </select>
			</td>						
		    <td class='title'>지급구분</td>
			<td width="37%">&nbsp;
			  <select name="pay_st" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="1" <%if(cons.getPay_st().equals("1")){%>selected<%}%>>선불</option>
			    <option value="2" <%if(cons.getPay_st().equals("2")){%>selected<%}%>>후불</option>								
  			  </select>
			</td>						
	      </tr>
		  <tr>
		    <td width="3%" rowspan="4" class='title'>요<br>
	        청</td>
		    <td width="10%" class='title'>세차</td>
		    <td colspan="3">&nbsp;
			  <select name="wash_yn" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="Y" <%if(cons.getWash_yn().equals("Y")){%>selected<%}%>>요청</option>
			    <option value="N" <%if(cons.getWash_yn().equals("N")){%>selected<%}%>>없음</option>								
  			  </select>
			</td>
	      </tr>
		  <tr>
		    <td class='title'>주유</td>
		    <td colspan="3">&nbsp;
			  <select name="oil_yn" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="Y" <%if(cons.getOil_yn().equals("Y")){%>selected<%}%>>요청</option>
			    <option value="N" <%if(cons.getOil_yn().equals("N")){%>selected<%}%>>없음</option>								
  			  </select>
			  <%if(cons.getOil_yn().equals("Y")){%>
				주유요청 -&gt; 
			  <%=Util.parseDecimal(cons.getOil_liter())%><input type='hidden' name="oil_liter" value='<%=Util.parseDecimal(cons.getOil_liter())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
				리터<!--ℓ--> 
				혹은
			  <%=Util.parseDecimal(cons.getOil_est_amt())%><input type='hidden' name="oil_est_amt" value='<%=Util.parseDecimal(cons.getOil_est_amt())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
				원어치 주유 해주세요.
			  <%}%>
			</td>
	      </tr>
	      <tr>
		    <td class='title'>하이패스<br>등록</td>
		    <td colspan="3">&nbsp;
			  <select name="hipass_yn">
        			    <option value="Y" <%if(cons.getHipass_yn().equals("Y")){%>selected<%}%>>요청</option>
        			    <option value="N" <%if(cons.getHipass_yn().equals("N")||cons.getHipass_yn().equals("")){%>selected<%}%>>없음</option>								
          			  </select>
					  (등록대행 의뢰시 선택하십시오.)
			</td>
	      </tr>
		  <tr>
		    <td class='title'>기타</td>
		    <td colspan="3">&nbsp;
              <%=cons.getEtc()%><!--<textarea rows='5' cols='90' name='etc' class='<%=white%>'></textarea>--></td>
	      </tr>		  
		</table>
	  </td>
	</tr>  	  
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>			
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        	<tr><td class=line2></td></tr>		  		  
		  <tr>
		    <td width="3%" rowspan="8" class='title'>출<br>발</td>
		    <td width="10%" class='title'>구분</td>
		    <td width="37%">&nbsp;
			  <select name="from_st" onChange="javascript:cng_input3('from', this.value, <%=j%>)" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="1" <%if(cons.getFrom_st().equals("1")){%>selected<%}%>>아마존카</option>
			    <option value="2" <%if(cons.getFrom_st().equals("2")){%>selected<%}%>>고객</option>
			    <option value="3" <%if(cons.getFrom_st().equals("3")){%>selected<%}%>>협력업체</option>
			    <option value="4" <%if(cons.getFrom_st().equals("4")){%>selected<%}%>>협력업체</option>				
  			  </select>
			  <%if(white.equals("")){%>		
			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
			  <%}%>
			</td>
		    <td width="3%" rowspan="8" class='title'>도<br>착</td>
		    <td width="10%" class='title'>구분</td>
		    <td width="37%">&nbsp;
			  <select name="to_st" onChange="javascript:cng_input3('to', this.value, <%=j%>)" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="1" <%if(cons.getTo_st().equals("1")){%>selected<%}%>>아마존카</option>
			    <option value="2" <%if(cons.getTo_st().equals("2")){%>selected<%}%>>고객</option>
			    <option value="3" <%if(cons.getTo_st().equals("3")){%>selected<%}%>>협력업체</option>				
  			  </select>
			  <%if(white.equals("")){%>			
			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
			  <%}%>
			</td>			
		  </tr>
		  <tr>
		    <td width="10%" class='title'>장소</td>
		    <td>&nbsp;<%=cons.getFrom_place()%>
                <input type='hidden' name="from_place" id="from_place" value='<%=cons.getFrom_place()%>' size='40' class='<%=white%>text' ></td>
		    <td width="10%" class='title'>장소</td>
		    <td>&nbsp;<%=cons.getTo_place()%>
                <input type='hidden' name="to_place" value='<%=cons.getTo_place()%>' size='40' class='<%=white%>text' ></td>
		  </tr>
		  <tr>
		    <td class='title'>상호/성명</td>
		    <td>&nbsp;<%=cons.getFrom_comp()%>
                <input type='hidden' name="from_comp" id="from_comp" value='<%=cons.getFrom_comp()%>' size='40' class='<%=white%>text' >
				</td>
		    <td class='title'>상호/성명</td>
		    <td>&nbsp;<%=cons.getTo_comp()%>
                <input type='hidden' name="to_comp" value='<%=cons.getTo_comp()%>' size='40' class='<%=white%>text' ></td>
		  </tr>
		  <tr>
		    <td class='title'>담당자</td>
	        <td>&nbsp;부서/직위:<%=cons.getFrom_title()%>
	          <input type='hidden' name="from_title" id="from_title" value='<%=cons.getFrom_title()%>' size='13' class='<%=white%>text' >
              &nbsp;성명:<%=cons.getFrom_man()%>
              <input type='hidden' name="from_man" id="from_man" value='<%=cons.getFrom_man()%>' size='8' class='<%=white%>text' >
			  <%if(white.equals("")){%>
			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
			  <%}%>
			</td>
		    <td class='title'>담당자</td>
		    <td>&nbsp;부서/직위:<%=cons.getTo_title()%>
		      <input type='hidden' name="to_title" value='<%=cons.getTo_title()%>' size='13' class='<%=white%>text' >
			  &nbsp;성명:<%=cons.getTo_man()%>
			  <input type='hidden' name="to_man" value='<%=cons.getTo_man()%>' size='8' class='<%=white%>text' >
			  <%if(white.equals("")){%>
			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
			  <%}%>
			</td>
		  </tr>
		  <tr>
		    <td class='title'>연락처</td>
		    <td>&nbsp;<%=cons.getFrom_tel()%>
                <input type='hidden' name="from_tel" id="from_tel" value='<%=cons.getFrom_tel()%>' size='15' class='<%=white%>text' >
				&nbsp;핸드폰:<%=cons.getFrom_m_tel()%>
                <input type='hidden' name="from_m_tel" id="from_m_tel" value='<%=cons.getFrom_m_tel()%>' size='15' class='<%=white%>text' >
			</td>
		    <td class='title'>연락처</td>
		    <td>&nbsp;<%=cons.getTo_tel()%>
                <input type='hidden' name="to_tel" value='<%=cons.getTo_tel()%>' size='15' class='<%=white%>text' >
				&nbsp;핸드폰:<%=cons.getTo_m_tel()%>
                <input type='hidden' name="to_m_tel" value='<%=cons.getTo_m_tel()%>' size='15' class='<%=white%>text' >
			</td>
		  </tr>
		  <tr>
		    <td class='title'>요청일시</td>
		    <td>&nbsp;
			  <%	String from_req_dt = "";
			  		String from_req_h = "";
					String from_req_s = "";
			  		if(cons.getFrom_req_dt().length() == 12){
						from_req_dt = cons.getFrom_req_dt().substring(0,8);
						from_req_h 	= cons.getFrom_req_dt().substring(8,10);
						from_req_s	= cons.getFrom_req_dt().substring(10,12);
					}%>
              <input type='text' name="from_req_dt" value='<%=AddUtil.ChangeDate2(from_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt[<%=j%>].value=this.value;'>
              &nbsp;
			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=j%>].value=this.value;" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
            </td>
		    <td class='title'>요청일시</td>
		    <td>&nbsp;
			  <%	String to_req_dt = "";
			  		String to_req_h = "";
					String to_req_s = "";
			  		if(cons.getTo_req_dt().length() == 12){
						to_req_dt 	= cons.getTo_req_dt().substring(0,8);
						to_req_h 	= cons.getTo_req_dt().substring(8,10);
						to_req_s 	= cons.getTo_req_dt().substring(10,12);
					}%>			
              <input type='text' name="to_req_dt" value='<%=AddUtil.ChangeDate2(to_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value)'>
              &nbsp;
			  <select name="to_req_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="to_req_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
            </td>
	      </tr>
		  <tr>
		    <td class='title'>예정일시</td>
		    <td>&nbsp;
			  <%	String from_est_dt = "";
			  		String from_est_h = "";
					String from_est_s = "";
			  		if(cons.getFrom_est_dt().length() == 12){
						from_est_dt = cons.getFrom_est_dt().substring(0,8);
						from_est_h 	= cons.getFrom_est_dt().substring(8,10);
						from_est_s	= cons.getFrom_est_dt().substring(10,12);
					}%>			
              <input type='text' name="from_est_dt" value='<%=AddUtil.ChangeDate2(from_est_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_est_dt[<%=j%>].value=this.value;'>
			  &nbsp;
			  <select name="from_est_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_est_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="from_est_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_est_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
			  </td>
	        <td class='title'>예정일시</td>
	        <td>&nbsp;
			  <%	String to_est_dt = "";
			  		String to_est_h = "";
					String to_est_s = "";
			  		if(cons.getTo_est_dt().length() == 12){
						to_est_dt 	= cons.getTo_est_dt().substring(0,8);
						to_est_h 	= cons.getTo_est_dt().substring(8,10);
						to_est_s 	= cons.getTo_est_dt().substring(10,12);
					}%>						
              <input type='text' name="to_est_dt" value='<%=AddUtil.ChangeDate2(to_est_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value);'>
			  &nbsp;
			  <select name="to_est_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="to_est_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
			  </td>
		  </tr>
		  <tr>
		    <td class='title'>인수일시</td>
		    <td>&nbsp;
			  <%	String from_dt = "";
			  		String from_h = "";
					String from_s = "";
			  		if(cons.getFrom_dt().length() == 12){
						from_dt = cons.getFrom_dt().substring(0,8);
						from_h 	= cons.getFrom_dt().substring(8,10);
						from_s	= cons.getFrom_dt().substring(10,12);
					}%>			
              <input type='text' name="from_dt" value='<%=AddUtil.ChangeDate2(from_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_est_dt[<%=j%>].value=this.value;'>
			  &nbsp;
			  <select name="from_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="from_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
			  </td>
	        <td class='title'>인도일시</td>
	        <td>&nbsp;
			  <%	String to_dt = "";
			  		String to_h = "";
					String to_s = "";
			  		if(cons.getTo_dt().length() == 12){
						to_dt 	= cons.getTo_dt().substring(0,8);
						to_h 	= cons.getTo_dt().substring(8,10);
						to_s 	= cons.getTo_dt().substring(10,12);
					}%>						
              <input type='text' name="to_dt" value='<%=AddUtil.ChangeDate2(to_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value);'>
			  &nbsp;
			  <select name="to_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="to_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
			  </td>
		  </tr>
		</table>
	  </td>
	</tr>  	  
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>			
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        	<tr><td class=line2></td></tr>		  		  		  
		  <tr>
		    <td width="13%" class='title'>운전자명</td>
            <td width="37%">&nbsp;<%=cons.getDriver_nm()%>
                <input type='hidden' name="driver_nm" value='<%=cons.getDriver_nm()%>' size='15' class='<%=white%>text'>
			</td>
            <td width="13%" class='title'>운전자핸드폰</td>
            <td width="37%">&nbsp;<%=cons.getDriver_m_tel()%>
            <input type='hidden' name="driver_m_tel" value='<%=cons.getDriver_m_tel()%>' size='15' class='<%=white%>text'></td>
	      </tr>		  
        </table>
      </td>
    </tr>		
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>	
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        	<tr><td class=line2></td></tr>
		  <tr>
		    <td width="13%" class='title'>탁송료</td>
	        <td width="10%" class='title'>유류비</td>
		    <td width="10%" class='title'>세차비</td>
		    <td width="17%" class='title'>기타내용</td>
		    <td width="13%" class='title'>기타금액</td>
		    <td width="13%" class='title'>소계</td>
		    <td width="12%" class='title'>청구일자</td>
		    <td width="12%" class='title'>지급일자</td>						
		  </tr>
		  <tr>
		    <td align="center"><%=AddUtil.parseDecimal(cons.getCons_amt())%><input type='hidden' name="cons_amt" value='<%=AddUtil.parseDecimal(cons.getCons_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
		    <td align="center"><%=AddUtil.parseDecimal(cons.getOil_amt())%><input type='hidden' name="oil_amt" value='<%=AddUtil.parseDecimal(cons.getOil_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
		    <td align="center"><%=AddUtil.parseDecimal(cons.getWash_amt())%><input type='hidden' name="wash_amt" value='<%=AddUtil.parseDecimal(cons.getWash_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
		    <td align="center"><%=cons.getOther()%><input type='hidden' name="other" value='<%=cons.getOther()%>' size='10' class='<%=white%>text'></td>
		    <td align="center"><%=AddUtil.parseDecimal(cons.getOther_amt())%><input type='hidden' name="other_amt" value='<%=AddUtil.parseDecimal(cons.getOther_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
		    <td align="center"><%=AddUtil.parseDecimal(cons.getTot_amt())%><input type='hidden' name="tot_amt" value='<%=AddUtil.parseDecimal(cons.getTot_amt())%>' size='7' class='<%=white%>num'></td>
		    <td align="center"><%=AddUtil.ChangeDate2(cons.getReq_dt())%><input type='hidden' name="req_dt" value='<%=AddUtil.ChangeDate2(cons.getReq_dt())%>' size='11' class='<%=white%>text'></td>
		    <td align="center"><%=AddUtil.ChangeDate2(cons.getPay_dt())%><input type='hidden' name="pay_dt" value='<%=AddUtil.ChangeDate2(cons.getPay_dt())%>' size='11' class='<%=white%>text'></td>						
		  </tr>
		</table>
	  </td>
    </tr>		
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>	
	<%if(cons.getCost_st().equals("2")){%>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        	<tr><td class=line2></td></tr>
		  <tr>
		    <td width="13%" class='title'><font color=red><b>고객탁송료</b></font></td>
	        <td width="37%">&nbsp;<%=AddUtil.parseDecimal(cons.getCust_amt())%>
			  <input type='hidden' name="cust_amt" value='<%=AddUtil.parseDecimal(cons.getCust_amt())%>' size='7' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
		    <td width="13%" class='title'>수령일자</td>
		    <td width="37%">&nbsp;<%=AddUtil.ChangeDate2(cons.getCust_pay_dt())%>
			  <input type='hidden' name="cust_pay_dt" value='<%=AddUtil.ChangeDate2(cons.getCust_pay_dt())%>' size='11' class='<%=white%>text'></td>
	      </tr>
		</table>
	  </td>
    </tr>		
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>				
	<%}%>
	<tr>
	  <td align="right"><a href="javascript:print()"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a></td>
	</tr>			
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>				
	<tr>
	  <td><font color=#CCCCCC>&nbsp;※인쇄TIP(explorer 6) : 프린트시 인터넷 익스플로어 화면 상단에 메뉴중 '도구>인터넷옵션>고급(상단맨우측)>인쇄>배경색 및 이미지 인쇄'가 체크 되어있어야 올바르게 인쇄됩니다.<br>
	  ※인쇄TIP(explorer 8,9) : 프린트시 인터넷 익스플로어 화면 상단에 메뉴중 '파일>페이지설정>용지옵션 란>배경색 및 이미지 인쇄(<u>C</u>)'가 체크 되어있어야 올바르게 인쇄됩니다.
	  </font></td>
	</tr>			
	<tr>
	  <td><font color=#CCCCCC>&nbsp;※페이지설정 : 프린트시 인터넷 익스플로어 화면 상단에 메뉴중 페이지설정에서 머리글/바닥글 공백으로 깨끗하게 인쇄됩니다.</font></td>
	</tr>			
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;	
//-->
</script>
</body>
</html>
