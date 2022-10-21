<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.car_office.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CarOfficeDatabase umd 	= CarOfficeDatabase.getInstance();
		
	CarCompBean cc_r [] = umd.getCarCompAllNew("1");
			
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();	
		
//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//담당자 리스트
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();	
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--		

	//자동차회사 선택시 차종코드 출력하기
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') fine_gov_search();
	}	
	
	//계약검색하기
	function find_car_search(){
		var fm = document.form1;
		
		if(fm.car_comp_id.value == '') { alert('제조사를 선택하십시오.'); return; }

		window.open("find_car_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&car_comp_id="+fm.car_comp_id.value+"&code="+fm.code.value , "SEARCH_FINE", "left=50, top=50, width=1000, height=700, resizable=yes, scrollbars=yes, status=yes");
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin=15>
<form action="get_car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_origin" value="">
  <input type="hidden" name="car_comp_id" value="">  
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">    
  <input type="hidden" name="t_wd" value="">      
  <input type="hidden" name="auth_rw" value="">
  <input type="hidden" name="mode" value="">
</form>

<form name='form1' action='bank_doc_reg_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>고객지원 >자동차관리 > <span class=style5>자동차리콜등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                   <input type="hidden" name="doc_id" size="15" class="text" value="<%=FineDocDb.getFineGovNoNext("리콜")%>">
                 <tr> 
                     <td class='title' width="10%"  rowspan=4>리콜접수</td>
                    <td class='title'  >접수일자</td>
                    <td>&nbsp; 
                      <input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                     <td class='title'  width="10%" rowspan=4 >리콜대응고지</td>
                     <td class='title'  >고지일자</td>
                    <td>&nbsp; 
                      <input type="text" name="print_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                 <tr> 
                    <td class='title' >접수형태</td>
                    <td>&nbsp; 
                      	<select name="f_reason" >
			    <option value="">---선택---</option>
			    <option value="1">문서</option>
			    <option value="2">전화</option>
			    <option value="3">기타</option>
			   </select>       
                    </td>
                        <td class='title' >고지형태</td>
                    <td>&nbsp; 
                     	<select name="f_result" >
			    <option value="">---선택---</option>
			    <option value="1">FMS공지</option>
			    <option value="2">문서</option>
			    <option value="3">전화</option>
			    <option value="4">메일</option>
			    <option value="5">기타</option>
			   </select>       
                    </td>
                </tr>
                 <tr> 
                    <td class='title' >담당자</td>
                    <td>&nbsp; 
                            <select name='reg_id'>
		                <option value="">선택</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
		                <%		}
							}%>
		              </select>
                    </td>
                        <td class='title' >담당자</td>
                    <td>&nbsp; 
                    	  <select name='print_id'>
		                <option value="">선택</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>	
                    </td>
                </tr>
                 <tr> 
                    <td class='title' >관리자</td>
                    <td>&nbsp; 
                     <select name='h_mng_id'>
		                <option value="">선택</option>
		                <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
		                <option value='<%=user1.get("USER_ID")%>' <%if(ck_acar_id.equals(user1.get("USER_ID"))){%>selected<%}%>><%=user1.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>	
                        </td>
                        <td class='title' >관리자</td>
                    <td>&nbsp; 
                   <select name='b_mng_id'>
		                <option value="">선택</option>
		                <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
		                <option value='<%=user1.get("USER_ID")%>' <%if(ck_acar_id.equals(user1.get("USER_ID"))){%>selected<%}%>><%=user1.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>	
                    </td>
                </tr>
              </table>
           </td>
      </tr>                          
      <tr>
        <td class=h></td>
    </tR>
	<tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>리콜내용</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
   
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
             <tr> 
                    <td  width="10%" class='title'>제조사</td>
                    <td>&nbsp;                     
                    	  <select name="car_comp_id" onChange="javascript:GetCarCode()">
                    	   <option value="">선택</option>
            					  
		                <%	for(int i=0; i<cc_r.length; i++){
								cc_bean = cc_r[i];
								if(cc_bean.getNm().equals("에이전트")) continue;%>
		                <option value="<%= cc_bean.getCode() %>" <% if(cc_bean.getCode().equals(car_comp_id)) out.print("selected"); %>><%= cc_bean.getNm() %></option>
		                <%	}	%>
		              </select> 
             
        		</td>
        		   <td class='title'>차종</td>
                    <td> &nbsp;  
                 			<select name="code" >
                                	  <option value="">선택</option>
                              	</select>            
                     </td>
                        <td  width="11%" class='title'>모델명</td>
                    <td  > &nbsp;  
                      <input type="text" name="mng_nm" size="50" class="text">                  
                     </td>       		
                </tr>                
                  <tr> 
                    <td  width="10%"  class='title'>대상구분</td>
                    <td > &nbsp;  
                    	<select name="gov_st" >
                                <option value="">---선택---</option>
			    <option value="1">제조일자</option>
			    <option value="2">옵션</option>
			</select>   		         
                     </td>
                        <td class='title'>개시일(제조일자)</td>
                    <td> &nbsp;  
                    <input type="text" name="s_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'> 
                     </td>
                        <td  width="11%"   class='title'>종료일(제조일자)</td>
                    <td> &nbsp;  
                      <input type="text" name="e_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
                     </td>       		
                </tr>      
           </table>
       </td>
   </tr>        
   <tr>
        <td class=h></td>
    </tR>

    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                  <tr> 
                    <td width="10%" class='title'>시행기간</td>
                    <td  colspan=3> &nbsp;  
                     <input type="text" name="ip_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>&nbsp;~&nbsp;  <input type="text" name="end_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>    
                     </td>
                </tr>     
               <tr> 
                    <td width="10%" class='title'>리콜방법</td>
                    <td  colspan=3> &nbsp;  
                      <input type="text" name="mng_dept" size="140" class="text">                  
                     </td>
                </tr>       
                <tr> 
                    <td  width="10%" class='title'>리콜처리처</td>
               	  <td  colspan=3>&nbsp; 
                          <input type="text" name="title" size="140" class="text"> 
                 </td>
                </tr>
                <tr> 
                    <td width="10%" class='title' style='height:38'>결함내용</td>
             	   <td  colspan=3>&nbsp; 
                       <textarea name="remarks" cols="140" class="text" style="IME-MODE: active" rows="2"></textarea> 
                    </td>                      
                </tr>            
            </table>
      </td>
    </tr>
    
    <tr>
        <td></td>
    </tr>
 
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td><a href="javascript:find_car_search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>		
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
