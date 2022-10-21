<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")	==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 	= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String asc 	= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String go_url 	= request.getParameter("go_url")	==null?"":request.getParameter("go_url");
	String idx 	= request.getParameter("idx")		==null?"":request.getParameter("idx");

	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	//height
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이				

	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");	

	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
			
	Vector accids = as_db.getAccidS9List(gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int accid_size = accids.size();
	//out.println(accid_size);
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	double tot_per = 0;
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language='javascript'>

<!--
		
	function updateIns_req(c_id, accid_id, seq){
		var fm = document.form1;
		
		fm.c_id.value 	= c_id;						
		fm.accid_id.value 	= accid_id;
		fm.seq.value 	= seq;
		
		if(confirm('대차료청구상태를 변경하시겠습니까?')){	
			if(confirm('진짜로 변경하시겠습니까?')){			
				fm.action='accid_i_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}									
		}									
	}
	
 //-->   
</script>
</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type='hidden' name='accid_size' value='<%=accid_size%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 500px;">
					<div style="width: 500px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>												        		
				        		<td width='40' class='title title_border'>연번</td>
			                    <td width='90' class='title title_border'>사고차량</td>
			                    <td width='100' class='title title_border'>사고차종</td>
				        	    <td width='80' class='title title_border'>대차차량</td>
				        	    <td width='60' class='title title_border'>사고유형</td>
				        	    <td width='130' class='title title_border'>사고일자</td>		        	    
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
						  <tr> 
				                <td width='100' class='title title_border'>구분</td>
			                    <td width='120' class='title title_border'>상대보험사</td>
			                    <td width='80' class='title title_border'>청구일자</td>			
			                    <td width='80' class='title title_border'>청구금액</td>
			                    <td width='80' class='title title_border'>입금금액</td>						
								<td width='80' class='title title_border'>비율</td>
			                    <td width='80' class='title title_border'>입금일자</td>			
			                    <td width='80' class='title title_border'>차액</td>
			                    <td width='80' class='title title_border'>연체이자</td>
			                    <td width='80' class='title title_border'>연체일수</td>
			                    <td width='80' class='title title_border'>총미납금액</td>
			                    <td width='90' class='title title_border'>최고서작성</td>
			                    <td width='80' class='title title_border'>소장작성일</td>
			                    <td width='60' class='title title_border'>청구담당</td>			
			              </tr>	                
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb" >
			<tr>
				<td style="width: 500px;">
					<div style="width: 500px;">
						<table class="inner_top_table left_fix">	
    	
				  <%	if(accid_size > 0){%>     
				    <% 		for (int i = 0 ; i < accid_size ; i++){
								Hashtable accid = (Hashtable)accids.elementAt(i);
								String req_st = String.valueOf(accid.get("REQ_ST"));%>
				          <tr style="height: 25px;">  
				            <td width='40' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><a name="<%=i+1%>"><%=i+1%></a></td>
				            <td width='90' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=accid.get("CAR_NO")%> 
				                      <%if(!String.valueOf(accid.get("PIC_CNT")).equals("0")){%> 
				                      <a href="javascript:openPopP('<%=accid.get("FILE_TYPE")%>','<%=accid.get("ATTACH_SEQ")%>');" title='보기' >[F]</a>
				                      <%}%>    
				            </td>
				            <td width='100' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><span title='<%=accid.get("CAR_NM")%>'><%=Util.subData(String.valueOf(accid.get("CAR_NM")), 6)%></span></td>
				            <td width='80' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=accid.get("D_CAR_NO")%></td>
				            <td width='60' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=accid.get("ACCID_ST_NM")%></td>
				            <td width='130' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><span style="letter-spacing: -1;"><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></span></td>
				          </tr>
				          <%		}%>
				          <tr> 
				            <td class='title content_border center' colspan="6" >&nbsp;</td>
				          </tr>
				     <%} else  {%>  
						  <tr>
						      <td class='center content_border '>등록된 데이타가 없습니다</td>
						  </tr>	              
					 <%}	%>
				      </table>
				   </div>
			   </td>
			   
			   <td>
					<div>
						<table class="inner_top_table table_layout">		  
						<%	if(accid_size > 0){%>
				         <%		for (int i = 0 ; i < accid_size ; i++){
								Hashtable accid = (Hashtable)accids.elementAt(i);
								String req_st = String.valueOf(accid.get("REQ_ST"));
								long t_req_amt = AddUtil.parseLong(String.valueOf(accid.get("DEF_AMT")))+AddUtil.parseLong(String.valueOf(accid.get("DLY_AMT")));%>
				            <tr style="height: 25px;">  
					            <td width='100' class='center content_border'  <%if(req_st.equals("3"))%>class=star<%%>><%=accid.get("SUIT_NM")%>
					                <%if (!String.valueOf(accid.get("SUIT_NM")).equals("민사불가") && !String.valueOf(accid.get("MEAN_DT")).equals("")  ) { %>
					              	   (종결)                         
					                <%} %>
					            </td>			 
					            <td width='120' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><span title='<%=accid.get("INS_COM")%>'><%=Util.subData(String.valueOf(accid.get("INS_COM")), 8)%></span></td>			
					            <td width='80' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=AddUtil.ChangeDate2(String.valueOf(accid.get("REQ_DT")))%></td>			
					            <td width='80' class='right content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=Util.parseDecimal(String.valueOf(accid.get("REQ_AMT")))%></td>
					            <td width='80' class='right content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=Util.parseDecimal(String.valueOf(accid.get("PAY_AMT")))%></td>
								<td width='80' class='right content_border' ><a href="javascript:updateIns_req('<%=accid.get("CAR_MNG_ID")%>','<%=accid.get("ACCID_ID")%>','<%=accid.get("SEQ_NO")%>');"><%=accid.get("DEF_PER2")%> %</a></td>				
					            <td width='80' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=AddUtil.ChangeDate2(String.valueOf(accid.get("PAY_DT")))%></td>
					            <td width='80' class='right content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=Util.parseDecimal(String.valueOf(accid.get("DEF_AMT")))%></td>
					            <td width='80' class='right content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=Util.parseDecimal(String.valueOf(accid.get("DLY_AMT")))%></td>
					            <td width='80' class='right content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=accid.get("DLY_DAYS")%></td>
					            <td width='80' class='right content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=Util.parseDecimal(t_req_amt)%></td>
					            <td width='90' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=AddUtil.ChangeDate2(String.valueOf(accid.get("F_DOC_REG_DT")))%><%if(!String.valueOf(accid.get("F_DOC_REG_DT")).equals("")){%>(<%=accid.get("F_DOC_CNT")%>)<%}%></td>						
					            <td width='80' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=AddUtil.ChangeDate2(String.valueOf(accid.get("SERV_DT")))%></td>						
					            <td width='60' class='center content_border' <%if(req_st.equals("3"))%>class=star<%%>><%=c_db.getNameById(String.valueOf(accid.get("BUS_ID2")),"USER")%></td>
					        </tr> 
					          
					          <%
					                total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(accid.get("REQ_AMT")));
							 		total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(accid.get("PAY_AMT")));
									total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(accid.get("DEF_AMT")));
									total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(accid.get("DLY_AMT")));
									total_amt5 = total_amt5 + t_req_amt;
									
							  	}%>
					        <tr> 
					            <td class="title content_border center" colspan='3'>합계</td>
					            <td class='title content_border right'><%=Util.parseDecimal(total_amt1)%></td>
					            <td class='title content_border right'><%=Util.parseDecimal(total_amt2)%></td>			
					            <td class='title content_border center'>&nbsp;</td>
								<td class='title content_border center'>&nbsp;</td>
					            <td class='title content_border right'><%=Util.parseDecimal(total_amt3)%></td>						
					            <td class='title content_border right'><%=Util.parseDecimal(total_amt4)%></td>						
					            <td class='title content_border center'>&nbsp;</td>					
					            <td class='title content_border right'><%=Util.parseDecimal(total_amt5)%></td>						                                    
					            <td class='title content_border center'>&nbsp;</td>			
					            <td class='title content_border center'>&nbsp;</td>						
					            <td class='title content_border center'>&nbsp;</td>							
					        </tr>
					<%} else  {%>  
							<tr>
							     <td  colspan="14" class='center content_border'>&nbsp;</td>
							</tr>	              
					   <%}	%>
			            </table>
			        </div>
			    </td>			    
			</tr>
		</table>
	</div>
</div>		    
</form>

</body>
</html>
