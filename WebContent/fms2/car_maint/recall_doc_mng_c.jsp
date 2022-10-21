<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*,  acar.user_mng.*"%>
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
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String car_comp_id  = "";
	String bank_nm = "";
	String cmd = "";
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);

	//대출신청 리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
			
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//담당자 리스트
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();	
	
	
			
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	
	//목록보기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "recall_doc_mng_frame.jsp";
		fm.submit();
	}			
	//수정하기
	function fine_update(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "bank_doc_mng_u.jsp";
		fm.submit();
	}	
	
		//삭제하기
	function fine_del(){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){	return;	}
		fm.target = "d_content";
		fm.action = "recall_doc_mng_d_a.jsp";
		fm.submit();
	}
	
	
	//수정하기
	function fine_upd(){
		window.open("recall_doc_mng_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=1000, height=500, resizable=yes, scrollbars=yes, status=yes");
	}

	function updatelist(){
		var fm = document.form1;	
		var car_comp_id = <%=FineDocBn.getGov_id()%>;
		window.open("recall_doc_list_u.jsp?doc_id=<%=doc_id%>&car_comp_id=<%=FineDocBn.getGov_id()%>", "CHANGE_ITEM", "left= 50, top=50, width=1050, height=800, resizable=yes, scrollbars=yes, status=yes");
	
	}	
	
	
	function bank_massges_reg(){
		var fm = document.form1;
		if(!confirm('쿨메신져로 메세지를 보내시겠습니까?')){	return;	}
		fm.cmd.value = "m";
		fm.target = "d_content";
		fm.action = "recall_doc_reg_sc_a.jsp";
		fm.submit();
	}
		
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body   leftmargin=15>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='bank_nm' value='<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%>'>
<input type='hidden' name='cmd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
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
        <td align="right">
        <% if (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("영업수당관리자",user_id) || nm_db.getWorkAuthUser("대출관리자",user_id)   ){%>
        <a href="javascript:fine_del();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>&nbsp;
	    <a href="javascript:fine_upd();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
	    <% } %>
	    <a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    
     <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
           
                 <tr> 
                     <td class='title' width="10%"  rowspan=4>리콜접수</td>
                    <td class='title'  >접수일자</td>
                    <td>&nbsp; <%=AddUtil.getDate3(FineDocBn.getDoc_dt())%>  </td>
                     <td class='title'  width="10%" rowspan=4 >리콜대응고지</td>
                     <td class='title'  >고지일자</td>
                    <td>&nbsp; <%=AddUtil.getDate3(FineDocBn.getPrint_dt())%>  </td>
                </tr>
                 <tr> 
                    <td class='title' >접수형태</td>
                    <td>&nbsp; 
                      	<select name="f_reason" >
			    <option value="">---선택---</option>
			    <option value="1" <%if(FineDocBn.getF_reason().equals("1"))%>selected<%%>>문서</option>          
			    <option value="2" <%if(FineDocBn.getF_reason().equals("2"))%>selected<%%>>전화</option>          
			    <option value="3" <%if(FineDocBn.getF_reason().equals("3"))%>selected<%%>>기타</option>      
			   </select>       
                    </td>
                        <td class='title' >고지형태</td>
                    <td>&nbsp; 
                     	<select name="f_result" >
			    <option value="">---선택---</option>
			    <option value="1" <%if(FineDocBn.getF_result().equals("1"))%>selected<%%>>FMS공지</option>          
			    <option value="2" <%if(FineDocBn.getF_result().equals("2"))%>selected<%%>>문서</option>          
			    <option value="3" <%if(FineDocBn.getF_result().equals("3"))%>selected<%%>>전화</option>      
			    <option value="4" <%if(FineDocBn.getF_result().equals("4"))%>selected<%%>>메일</option>          
			    <option value="5" <%if(FineDocBn.getF_result().equals("5"))%>selected<%%>>기타</option>      			    
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
		                  <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getReg_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
		                  
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
		                   <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getPrint_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
		  
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
			       <option value='<%=user1.get("USER_ID")%>' <%if(FineDocBn.getH_mng_id().equals((String)user1.get("USER_ID")))%>selected<%%>><%=user1.get("USER_NM")%></option>
		                		  
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
			      <option value='<%=user1.get("USER_ID")%>' <%if(FineDocBn.getB_mng_id().equals((String)user1.get("USER_ID")))%>selected<%%>><%=user1.get("USER_NM")%></option>						
		            		  
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
                    <td width="20%" >&nbsp;<%=c_db.getNameById(FineDocBn.getGov_id(),"CAR_COM")%></td>
        		   <td width="11%"  class='title'>차종</td>
                     <td width="20%" > &nbsp;<%=c_db.getNameById(FineDocBn.getGov_id()+FineDocBn.getMng_pos(),"CAR_MNG")%> </td>
                      <td  width="11%" class='title'>모델명</td>
                    <td   width="28%" > &nbsp; <%= FineDocBn.getMng_nm()%> </td>    
                </tr>                
                  <tr> 
                    <td  width="10%"  class='title'>대상구분</td>
                    <td > &nbsp;  
                    	<select name="gov_st" >
                               <option value="">---선택---</option>
                               <option value="1" <%if(FineDocBn.getGov_st().equals("1"))%>selected<%%>>제조일자</option>          
                               <option value="2" <%if(FineDocBn.getGov_st().equals("2"))%>selected<%%>>옵션</option>    
			</select>   		         
                     </td>
                        <td class='title'>개시일(제조일자)</td>
                 	     <td> &nbsp;<%=AddUtil.ChangeDate2(FineDocBn.getS_dt())%> </td>   
                        <td  width="11%"   class='title'>종료일(제조일자)</td>              
                        <td> &nbsp;<%=AddUtil.ChangeDate2(FineDocBn.getE_dt())%> </td>                    
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
                    <td  colspan=3> &nbsp; <%=AddUtil.ChangeDate2(FineDocBn.getIp_dt())%> ~ <%=AddUtil.ChangeDate2(FineDocBn.getEnd_dt())%>  </td> 
                </tr>     
               <tr> 
                    <td width="10%" class='title'>리콜방법</td>
                    <td  colspan=3> &nbsp; <%= FineDocBn.getMng_dept()%> </td>   
               </tr>       
                <tr> 
                    <td  width="10%" class='title'>리콜처리처</td>
               	  <td  colspan=3>&nbsp; <%= FineDocBn.getTitle()%> </td>   
                </tr>
                <tr> 
                    <td width="10%" class='title' style='height:38'>결함내용</td>
             	   <td  colspan=3>&nbsp; 
             	     <textarea name="remarks" cols="140" class="text" style="IME-MODE: active" rows="2"><%=FineDocBn.getRemarks()%></textarea>                   
                    </td>                      
                </tr>            
            </table>
      </td>
    </tr>
         
    <tr>
        <td></td>
    </tr>

  <tr>
        <td class=h></td>
    </tR>
    <tr>    	
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>리콜대상현황(진행중/완결)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
  
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="8%">연번</td>
                    <td class='title' width="10%">차량번호</td>
                    <td class='title' width="15%">차종</td>
                    <td class='title' width="22%">차대번호</td>
                    <td class='title' width="20%"계약자</td>
                    <td class='title' width="8%">계약구분</td>
                    <td class='title' width="9%">관리담당</td>
                    <td class='title' width="8%">대응구분</td>                   
                </tr>
           
                  <% if(FineList.size()>0){
        				for(int i=0; i<FineList.size(); i++){ 
        					FineDocListBn = (FineDocListBean)FineList.elementAt(i);         						
        		 %>					
                <tr align="center"> 
                    <td><%=i+1%></td>			
                    <td><%=FineDocListBn.getCar_no()%></td>
                    <td><%=FineDocListBn.getVar1()%></td>
                    <td><%=FineDocListBn.getPaid_no()%></td>
                    <td> <%=FineDocListBn.getFirm_nm()%></td>
                    <td><%=FineDocListBn.getVar2()%></td>
                    <td><%=c_db.getNameById(FineDocListBn.getVar3(),"USER")%></td>
                     <td> <%if(FineDocListBn.getChk().equals("Y")) { %>완결 <% } else { %>미결  <% } %> </td>
                </tr>
				
                  <% 	}
				  
        			} %>
				
            </table>
        </td> 
    </tr>
    
       <tr>
        <td></td>
    </tr>
    
      <tr>
        <td class=h></td>
    </tR>
    <tr>
    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>리콜실시현황&nbsp;<a href="javascript:updatelist()"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
  
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="8%">연번</td>
                    <td class='title' width="10%">차량번호</td>
                    <td class='title' width="32%">정비/교환내역</td>
                    <td class='title' width="10%">관리담당</td>
                    <td class='title' width="12%">시행자</td>
                    <td class='title' width="18%">시행처</td>
                    <td class='title' width="10%">시행일자</td>
               
                </tr>
           
                  <% if(FineList.size()>0){
        				for(int i=0; i<FineList.size(); i++){ 
        					FineDocListBn = (FineDocListBean)FineList.elementAt(i);         						
        		 %>					
                <tr align="center"> 
                    <td><%=i+1%></td>			
                    <td><%=FineDocListBn.getCar_no()%></td>
                    <td><%=FineDocListBn.getRep_cont()%></td>
                    <td><%=c_db.getNameById(FineDocListBn.getVar3(),"USER")%></td>
                    <td><%if(FineDocListBn.getChecker_st().equals("1")) { %>관리자 <% } else { %>고객  <% } %></td>
                    <td><%=FineDocListBn.getServ_off_nm()%> </td>
                    <td><%=AddUtil.ChangeDate2(FineDocListBn.getServ_dt())%></td>
            
                </tr>
				
                  <% 	}
				  
        			} %>
				
            </table>
        </td> 
    </tr>
  
</table>
</form>

</body>
</html>
