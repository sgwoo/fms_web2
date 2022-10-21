<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.res_search.*, acar.cont.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String s_cd 	= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String firm_nm 	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String cust_id 	= request.getParameter("cust_id")==null?"":request.getParameter("cust_id");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	Vector conts = new Vector();
	int cont_size = 0;
	
	conts = rs_db.getTarchaContSearchList(firm_nm, t_wd);
	cont_size = conts.size();
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;		
		fm.action = 'sub_select_6_t.jsp';
		fm.target = '_self';
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	function SetCont(rent_mng_id, rent_l_cd){
		var fm = document.form1;		
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.action = 'sub_select_6_t.jsp';
		fm.target = '_self';
		fm.submit();		
	}
	
	<%if(!rent_l_cd.equals("")){%>
	//수정
	function update(){
		var fm = document.form1;
		
		if(fm.tae_car_rent_st.value == '')	{ alert('출고전대차-대여개시일을 입력하십시오.'); 		fm.tae_car_rent_st.focus(); return; }
		if(fm.tae_req_st.value == '')		{ alert('출고전대차-청구여부를 선택하십시오.'); 		fm.tae_req_st.focus(); 		return; }
		if(fm.tae_req_st.value == '1'){
//			if(fm.tae_rent_fee.value == '')	{ alert('출고전대차-월대여료를 입력하십시오.'); 		fm.tae_rent_fee.focus(); 	return; }
			if(fm.tae_tae_st.value == '')	{ alert('출고전대차-계산서발행여부를 선택하십시오.'); 	fm.tae_tae_st.focus(); 		return; }						
			if(fm.tae_sac_id.value == '')	{ alert('출고전대차-결재자를 선택하십시오.'); 			fm.tae_sac_id.focus(); 		return; }
			
			if(toInt(parseDigit(fm.tae_rent_fee.value))>0){
					fm.tae_rent_fee_s.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.tae_rent_fee.value))));
					fm.tae_rent_fee_v.value 	= parseDecimal(toInt(parseDigit(fm.tae_rent_fee.value)) - toInt(parseDigit(fm.tae_rent_fee_s.value)));						
			}
		}
		
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='sub_select_6_t_a.jsp';		
//			fm.target='i_no';
			fm.target='_self';
			fm.submit();
		}							
	}	
	<%}%>
	
//-->
</script>
</head>
<body leftmargin="15" javascript="document.form1.t_wd.focus();">
<table border=0 cellspacing=0 cellpadding=0 width=800>
  <form name="form1" method="post" action="sub_select_3_a2.jsp">
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>
<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>

    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약일자 : </span>
			<input type='text' name='t_wd' size='15' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		    <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td  class=line>
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="50">연번</td>
                    <td class=title width="200">상호</td>										
                    <td class=title width="100">계약번호</td>					
                    <td class=title width="100">차량번호</td>
                    <td class=title width="250">차명</td>
                    <td class=title width="100">계약일자</td>
                </tr>
				<%	if(cont_size > 0){
						for(int i = 0 ; i < cont_size ; i++){
							Hashtable sfm = (Hashtable)conts.elementAt(i);%>
        		<tr> 
       		      <td align="center"><%=i+1%></td>
       		      <td align="center"><%=sfm.get("FIRM_NM")%></td>
       		      <td align="center"><a href="javascript:SetCont('<%=sfm.get("RENT_MNG_ID")%>', '<%=sfm.get("RENT_L_CD")%>')"><%=sfm.get("RENT_L_CD")%></a></td>
       		      <td align="center"><%=sfm.get("CAR_NO")%></td>				  
       		      <td align="center"><%=sfm.get("CAR_NM")%>&nbsp;<%=sfm.get("CAR_NM")%></td>
       		      <td align="center"><%=sfm.get("RENT_DT")%></td>
        	    </tr>							
				<%		}
			  		}else{%>
				<tr> 
                  <td colspan=6 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>	
				<%	}%>	
            </table>
        </td>
    </tr>
	<%if(!rent_l_cd.equals("")){
		//계약기본정보
		ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		//신차대여정보
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
		
		if(taecha_no.equals("")){
			taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
		}
				
		//출고지연대차
		ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
		
		//담당자 리스트
		Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
		int user_size = users.size();
		%>
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr>
        <td><hr></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고전대차</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>출고전대차여부</td>
                    <td width="20%">&nbsp;있다
					  <input type='hidden' name='prv_dlv_yn' value='Y'>
        		    </td>
                    <td width="10%" class=title style="font-size : 7pt;">대차기간포함여부</td>
                    <td>&nbsp;<%if(fee.getPrv_mon_yn().equals("")) fee.setPrv_mon_yn("0"); %>
                      <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> >
                      미포함
                      <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> >
        	 		  포함
        		    </td>						
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>차량번호</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='tae_car_no' size='12' class='whitetext' readonly value='<%=reserv.get("CAR_NO")%>'>
        			  <input type='hidden' name='tae_no'		 value='0'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=c_id%>'>
					  <input type='hidden' name='tae_s_cd'	 	 value='<%=s_cd%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=reserv.get("CAR_ID")%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=reserv.get("CAR_SEQ")%>'>
        			</td>
                    <td width="10%" class='title'>차명</td>
                    <td>&nbsp;
                      <input type="text" name="tae_car_nm" size="15" maxlength='10' readonly class=whitetext value='<%=reserv.get("CAR_NM")%>'></td>
                    <td class='title'>최초등록일</td>
                    <td>&nbsp; 
                    <input type="text" name="tae_init_reg_dt" size="15" maxlength='10' readonly class=whitetext value='<%=reserv.get("INIT_REG_DT")%>'></td>
                </tr>
                <tr>
                    <td class=title>대여개시일</td>
                    <td>&nbsp;
                      <input type='text' name='tae_car_rent_st' class='text' size='12' maxlength='12' value='<%if(!taecha.getCar_rent_st().equals("")){%><%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%><%}else{%><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%><%}%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='title'>대여만료일</td>
                    <td colspan='3' >&nbsp;
                      <input type='text' name='tae_car_rent_et' class='text' size='12' maxlength='12' value='<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
        			  &nbsp;</td>
                </tr>
                <tr>
                    <td class=title>월대여료</td>
                    <td colspan='5' >&nbsp;
                      <input type='text' name='tae_rent_fee' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함) 
        			  <input type='hidden' name='tae_rent_fee_s'	 value=''>
        			  <input type='hidden' name='tae_rent_fee_v'	 value=''>					  					  
        			</td>                    
              </tr>		
              <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              <%}else{%>
              <tr>
                    <td class=title>신차해지시요금정산</td>
                    <td colspan='5' >&nbsp;
                      <input type='radio' name="tae_rent_fee_st" value='1' <%if(taecha.getRent_fee_st().equals("1")){%> checked <%}%> >
                                      월렌트정상요금
                      <input type='text' name='tae_rent_fee_cls' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함)                 
                      <input type='radio' name="tae_rent_fee_st" value='0' <%if(taecha.getRent_fee_st().equals("0")){%> checked <%}%>  >
    	 		          견적서에 표기되어 있지 않음                        				  					 
        			</td>                    
              </tr>			  
              <%} %>
              <tr>
                <td class=title>청구여부</td>
                <td>&nbsp;
                  <select name='tae_req_st'>
                    <option value="">선택</option>
                    <option value="1" <% if(taecha.getReq_st().equals("1")) out.print("selected");%>>청구</option>
                    <option value="0" <% if(taecha.getReq_st().equals("0")) out.print("selected");%>>무상대차</option>
                  </select></td>
                <td class='title' style="font-size : 8pt;">계산서발행여부</td>
                <td>&nbsp;
                  <select name='tae_tae_st'>
                    <option value="">선택</option>
                    <option value="1" <% if(taecha.getTae_st().equals("1")) out.print("selected");%>>발행</option>
                    <option value="0" <% if(taecha.getTae_st().equals("0")) out.print("selected");%>>미발행</option>
                  </select></td>
                <td class='title'>결재자</td>
                <td>&nbsp;
                  <select name='tae_sac_id'>
                    <option value="">선택</option>
                   	<%	if(user_size > 0){
    						for(int i = 0 ; i < user_size ; i++){
    							Hashtable user = (Hashtable)users.elementAt(i); %>
               		<option value='<%=user.get("USER_ID")%>' <%if(taecha.getTae_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                  	<%		}
    					}%>
                  </select>
    			</td>
              </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:update()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>		
	<%}%>
	
</form>
</table>
</body>
</html>