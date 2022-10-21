<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
		
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;
				
		if(confirm('수정하시겠습니까?')){	
			fm.action='reg_addamt_a.jsp';		
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}							
	}
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>   
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="emp_id" 			value="<%=emp1.getEmp_id()%>">
  <input type='hidden' name="agnt_st" 		value="<%=emp1.getAgnt_st()%>">  
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>영업수당 가감금액 선입력</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  	
    <tr>
        <td class=line2></td>
    </tr>    
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>계약번호</td>
            <td width=20%>&nbsp;<%=rent_l_cd%></td>
            <td class=title width=10%>상호</td>
            <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
            <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>차명<%}else{%>차량번호<%}%></td>
            <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
          </tr>
          <tr> 
            <td class=title width=10%>출고일자</td>
            <td width=20%>&nbsp;<%=AddUtil.ChangeDate2(base.getDlv_dt())%></td>
            <td class=title width=10%>최초등록일</td>
            <td width=20%>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
            <td class=title width=10%>대여개시일</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
          </tr>
		</table>
	  </td>
	</tr>  	 	 
	<tr>
	  <td align="right">&nbsp;</td>
	<tr>  
    <tr>
        <td class=line2></td>
    </tr>   		
    <tr> 	
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width="10%" class='title'>영업사원</td>
            <td colspan="5">&nbsp;
              <%=emp1.getEmp_nm()%>             
		    </td>
          </tr>
          <tr>
            <td width="10%" class='title'>소속사</td>
            <td width="20%">&nbsp;
              <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%></td>
            <td width="10%" class='title'>영업소명</td>
            <td width="20%">&nbsp;
              <%=emp1.getCar_off_nm()%>
            </td>
            <td width="10%" class='title'>구분</td>
            <td>&nbsp;
              <%=emp1.getCar_off_st()%>
            </td>
          </tr>
		</table>
	  </td>
	</tr>  	 
    <tr>
        <td class=h></td>
    </tr>  		 
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>가감내용</span></td>
	<tr>
    <tr>
        <td class=line2></td>
    </tr>   		  
    <tr> 	
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr> 
                    <td width=3% rowspan="4" class=title>가<br>감<br></td>
                    <td class=title width=12%>구분</td>
                    <td class=title width=10%>금액</td>			
                    <td class=title width=50%>적요</td>
                </tr>	
                <tr>
                    <td align="center">
        			        <select name="add_st1">
                        <option value="">==선택==</option>
        				        <option value="1" <%if(emp1.getAdd_st1().equals("1"))%>selected<%%>>세전</option>
        				        <option value="2" <%if(emp1.getAdd_st1().equals("2"))%>selected<%%>>세후</option>
        			        </select>
        			      </td>			
                    <td align="center"><input type='text' name='add_amt1' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt1())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input name="add_cau1" type="text" class="text" value="<%=emp1.getAdd_cau1()%>" size="50"></td>
                </tr>
                <tr>
                    <td align="center">
        			        <select name="add_st2">
                        <option value="">==선택==</option>
        				        <option value="1" <%if(emp1.getAdd_st2().equals("1"))%>selected<%%>>세전</option>
        				        <option value="2" <%if(emp1.getAdd_st2().equals("2"))%>selected<%%>>세후</option>
        			        </select>
        			      </td>			
                    <td align="center"><input type='text' name='add_amt2' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt2())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input name="add_cau2" type="text" class="text" value="<%=emp1.getAdd_cau2()%>" size="50"></td>
                </tr>
                <tr>
                    <td align="center">
        			        <select name="add_st3">
                        <option value="">==선택==</option>
        				        <option value="1" <%if(emp1.getAdd_st3().equals("1"))%>selected<%%>>세전</option>
        				        <option value="2" <%if(emp1.getAdd_st3().equals("2"))%>selected<%%>>세후</option>
        			        </select>
        			      </td>			
                    <td align="center"><input type='text' name='add_amt3' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt3())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input name="add_cau3" type="text" class="text" value="<%=emp1.getAdd_cau3()%>" size="50"></td>
                </tr>
        </table>
      </td>
    </tr>
    <tr>
	  <td align='center'>&nbsp;</td>
	</tr>	
    <tr>
	  <td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <%	if(base.getBus_id().equals(user_id) || nm_db.getWorkAuthUser("총무팀남",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("에이전트관리",user_id) || nm_db.getWorkAuthUser("에이전트관리2",user_id) || nm_db.getWorkAuthUser("에이전트관리3",user_id)){ %>
	      <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;			  
	    <%  }%>  
	    <%}%>
	    <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	  </td>
	</tr>	
  </table>
</form>
<script language="JavaScript">
<!--		
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>


