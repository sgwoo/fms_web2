<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"4":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	
	String cmd			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
		
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	//대출신청리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id, s_kd, t_wd);

	
    
   	  int scd_size= 0; //total    
     	scd_size =FineList.size(); 
     	
     	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
			
	function save()
	{
		var fm = document.form1;
		
		if(confirm('변경하시겠습니까?'))
		{		
			fm.target = 'i_no';			
			fm.action = 'recall_doc_list_reg_a.jsp'
			fm.submit();
		}		
		
	}
	
		//디스플레이 타입(검색) -검색조건 선택시
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //영업담당자
			td_input.style.display	= 'none';
			td_bus.style.display	= '';			
	
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //차량번호
			fm.gubun2.value = '5';
			td_input.style.display	= '';
			td_bus.style.display	= 'none';			
						
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';						
		}
	}
	
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'	){ //관리담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
				
		fm.submit();
	}	
	
	function doc_list_del(rent_l_cd)
	{
		var fm = document.form1;
		fm.cmd.value = "d";
		fm.rent_l_cd.value = rent_l_cd;
		if(confirm('삭제하시겠습니까?')){	
				fm.action='recall_doc_list_reg_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}
	}	
		
//-->	
</script>
</head>
<body leftmargin="15" >

<form action="recall_doc_list_u.jsp" name="form1" method="POST" >

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
<input type='hidden' name='scd_size' value='<%=scd_size%>'>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='rent_l_cd' value=''>
  <table width='1000' border="0" cellpadding="0" cellspacing="0">
     <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>고객지원 > 자동차관리 > <span class=style5>자동차리콜관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    
      <tr> 
        <td>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>           
                <tr> 
                    <td  width=19%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif  align=absmiddle>&nbsp;  
                          <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                        
                            <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차량번호</option>                          
                            <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>관리담당자</option>            		
                          </select>
                    </td>
                    <td> 
                        <table width="100%" height="21" border="0" cellpadding="0" cellspacing="0">
                            <tr> 
                                <td id='td_input' <%if(s_kd.equals("8")){%> style='display:none'<%}%>> 
                                    <input type='text' name='t_wd' size='16' class='text' value='<%if(s_kd.equals("")){ out.print(t_wd);}else{out.print(cnd.getT_wd());}%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
                                </td>
                                <td id='td_bus' <%if(s_kd.equals("8")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                                    <select name='s_bus'>
                                       <%if(user_size > 0){
                							for(int i = 0 ; i < user_size ; i++){
                								Hashtable user = (Hashtable)users.elementAt(i); 
                						%>
                		          				     <option value='<%=user.get("USER_ID")%>' <%if(s_bus.equals(user.get("USER_ID"))||t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		                <%	}
                						}		%>
                					</select> </td>                                 
                          
                            </tr>
                        </table>
                    </td>
                   <td align='right'><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp; 
                    </td>
              </table>
        </td>
    </tr>           
                    
    <tr>
        <td class=line2></td>
    </tr>
 
	<tr> 
	      <td class="line">
		  <table width="100%" border="0" cellspacing="1" cellpadding="0">
	     	       
	        <tr align="center">
	       <td class='title' width="7%">연번</td>
                    <td class='title' width="10%">차량번호</td>
                    <td class='title' width="31%">정비/교환내역</td>
                    <td class='title' width="9%">관리담당</td>
                    <td class='title' width="10%">시행자</td>
                    <td class='title' width="17%">시행처</td>
                    <td class='title' width="8%">시행일자</td>	 
                    <td class='title' width="8%">대응구분</td>	  
	        </tr>	     
	
         <% if(FineList.size()>0){
        				for(int i=0; i<FineList.size(); i++){ 
        					FineDocListBn = (FineDocListBean)FineList.elementAt(i);         		
							
	%>
	       <tr align="center"> 
	       	<input type='hidden' name='seq_no' value='<%=FineDocListBn.getSeq_no()%>'>
                    <td><a href="javascript:doc_list_del('<%=FineDocListBn.getRent_l_cd()%>')">D</a>&nbsp;<%=i+1%></td>			
                    <td><%=FineDocListBn.getCar_no()%></td>
                    <td><input type='text' name='rep_cont' size='40' class='text'  maxlength=100  value='<%=FineDocListBn.getRep_cont()%>' ></td>
                    <td><%=c_db.getNameById(FineDocListBn.getVar3(),"USER")%></td>                    
                    <td>&nbsp; 
                    	<select name="checker_st" >
			    <option value="">---선택---</option>
			    <option value="1" <%if(FineDocListBn.getChecker_st().equals("1"))%>selected<%%>>관리자</option>          
			    <option value="2" <%if(FineDocListBn.getChecker_st().equals("2"))%>selected<%%>>고객</option>          			    
			   </select>       
                   </td>
                    <td><input type='text' name='serv_off_nm' size='25' class='text'  maxlength=50  value='<%=FineDocListBn.getServ_off_nm()%>' ></td>
                    <td><input type='text' name='serv_dt' size='12' class='text'  value='<%=FineDocListBn.getServ_dt()%>'  onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
                     <td>&nbsp; 
                    	<select name="chk" >
			    <option value="">---선택---</option>
			    <option value="Y" <%if(FineDocListBn.getChk().equals("Y"))%>selected<%%>>완결</option>          
			    <option value="N" <%if(FineDocListBn.getChk().equals("N"))%>selected<%%>>미결</option>          			    
			   </select>       
                   </td>
            
                </tr>
    <% 	} %>
	 
	    </table>
        </td> 
    </tr>  
	     
<%} %>
    <tr> 
      <td height="5" align="center"></td>
    </tr>	
  	
    <tr>
		<td align="right">		
		 <a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
		  &nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>	  	
		</td>
	</tr>	
	
  </table>
 
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
