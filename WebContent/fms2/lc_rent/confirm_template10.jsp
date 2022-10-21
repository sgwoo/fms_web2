<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*,acar.insur.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*, acar.accid.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>


<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String ch_cd[] = request.getParameterValues("ch_cd");
	String user_type 	= request.getParameter("user_type")==null?"":request.getParameter("user_type");
	String user_name 	= request.getParameter("user_name")==null?"":request.getParameter("user_name");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String mail_yn = request.getParameter("mail_yn")	==null? "":request.getParameter("mail_yn");
	
	int vid_size 		= 0;
	
	vid_size = ch_cd.length;
	
	UsersBean ins_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산보험담당"));
	
	String r_fee_est_dt="";
	
	
	String rent_mng_id = "";
	String rent_l_cd = "";
	
	int amt_comp = 0;
	String item = "";
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
    font-family: "맑은 고딕", Malgun Gothic, "굴림", gulim,"돋움", dotum, arial, helvetica, sans-serif;
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
    border: 1px #888 solid ;
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
        margin: 0 !important; 
      	padding: 0 !important;
      	overflow: hidden;
    }
.paper {
    margin: 0;
    border: initial;
    border-radius: initial;
    width: initial;
    min-height: initial;
    box-shadow: initial;
    background: initial;
    page-break-after: auto;
}

}
table {
    border-collapse: collapse;
}

table, th, td {
    border: 1px solid black;
}

</style>

</head>
<body >
<object id="factory" style="display:none" > 
</object> 
<form action="" name="form1" method="POST" >
    <div class="paper">
        <div class="content">
        	<div id="top" style="  "><!-- 전체 비율 중 상단비율   -->
	        		<div id="title" align="center" style="padding:20px;"> 
	        			<p style="margin:0px;display:inline-block;font-size:18pt;border-bottom-style: double;">자동차보험 계약사항 변경 요청서</p>
	        		</div>
	        		<div style="text-align:right;">
	        			<p style="margin:0px;display:inline-block;">주식회사 아마존카 귀중</p>
	        		</div>
        	</div>
    		<div id="container" style="background-color:white;"> <!-- 전체 비율 중 중앙비율  -->
    			<div id="con1">
    				<div id="con1Title">
    					<p style="font-size:11pt;display:inline-block;padding:0px 0px 0px 20px;margin-bottom: 5px;">■ 변경 요청할 내용</p>
    				</div>
    				<table width="610" height="30" align="center" >
		                <tr align="center"> 
		                    <td style="font-size : 11pt;" width="20%">차량번호</td>
		                    <td style="font-size : 11pt;" width="20%">차명</td>
		                    <td style="font-size : 11pt;" width="20%">변경구분</td>
		                    <td style="font-size : 11pt;" width="20%">변경전</td>
		                    <td style="font-size : 11pt;" width="20%">변경후</td>			
		                </tr>
                        <%	 	
                        	String ch_after = "";
                        	for(int i=0;i < vid_size;i++){
            				//보험변경
            				InsurChangeBean d_bean = ins_db.getInsChangeDoc(ch_cd[i]);
            					
            				//보험변경리스트
            				Vector ins_cha = ins_db.getInsChangeDocList(ch_cd[i]);
            				int ins_cha_size = ins_cha.size();
            					
            				//계약조회
            				Hashtable cont = as_db.getRentCase(d_bean.getRent_mng_id(), d_bean.getRent_l_cd());
            				
            				rent_mng_id = d_bean.getRent_mng_id();
            				rent_l_cd =  d_bean.getRent_l_cd();
            				
            				//보험정보
            				ins = ins_db.getInsCase((String)cont.get("CAR_MNG_ID"), d_bean.getIns_st());
            				//System.out.println(ins.getCar_use());
            				
            				r_fee_est_dt = String.valueOf(d_bean.getR_fee_est_dt());
            				
            				int cont_dis = 0;
            				int fee_cng = 0;
            				if(d_bean.getD_fee_amt()>0 || d_bean.getD_fee_amt()<0) fee_cng = 1;
		                %>
		                
						<tr bgcolor="#FFFFFF" align="center"  height="30">
						    <td style="font-size : 11pt;" width="20%" <%if(ins_cha_size+fee_cng>1){%>rowspan='<%=ins_cha_size+fee_cng%>'<%}%>><%=cont.get("CAR_NO")%><%if(ins_cha_size>1){%><br>(<%=ins_cha_size%>건)<%}%></td>
						    <td style="font-size : 11pt;" width="20%" <%if(ins_cha_size+fee_cng>1){%>rowspan='<%=ins_cha_size+fee_cng%>'<%}%>><%=cont.get("CAR_NM")%></td>
						    <%	for(int j = 0 ; j < 1 ; j++){
									InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(j);%>
						    <td style="font-size : 10pt;" width="20%" >
							<%if(cha.getCh_item().equals("10")){%>대인2가입금액<%}%>
							<%if(cha.getCh_item().equals("1")){%>대물가입금액<%}%>
							<%if(cha.getCh_item().equals("2")){%>자기신체사고가입금액(사망/장애)<%}%>
							<%if(cha.getCh_item().equals("12")){%>자기신체사고가입금액(부상)<%}%>
							<%if(cha.getCh_item().equals("7")){%>대물+자기신체사고가입금액<%}%>
							<%if(cha.getCh_item().equals("3")){%>무보험차상해특약<%}%>
							<%if(cha.getCh_item().equals("4")){%>자기차량손해가입금액<%}%>
							<%if(cha.getCh_item().equals("9")){%>자기차량손해자기부담금<%}%>
							<%if(cha.getCh_item().equals("5")){%>연령변경<% item = "연령변경";}%>
							<%if(cha.getCh_item().equals("6")){%>애니카특약<%}%>
							<%if(cha.getCh_item().equals("8")){%>차종변경<%}%>
							<%if(cha.getCh_item().equals("11")){%>차량대체<%}%>
							<%if(cha.getCh_item().equals("13")){%>기타<%}%>
							<%if(cha.getCh_item().equals("14")){%>임직원한정운전특약<%}%>
							<%if(cha.getCh_item().equals("15")){%>피보험자변경<%}%>
							<%if(cha.getCh_item().equals("16")){%>고객피보험자 보험갱신<%}%>
							<%if(cha.getCh_item().equals("17")){%>블랙박스<%}%>
							<%if(cha.getCh_item().equals("18")){%>견인고리<%}%>
		   					</td>
						    <td style="font-size : 10pt;" width="20%">
						    	<%if(cha.getCh_item().equals("5") && (cha.getCh_before().equals("21세이상")||cha.getCh_before().equals("24세이상")||cha.getCh_before().equals("26세이상")||cha.getCh_before().equals("30세이상")||cha.getCh_before().equals("35세이상")||cha.getCh_before().equals("43세이상")||cha.getCh_before().equals("48세이상"))){%>
						    	만<%=cha.getCh_before()%>
						    	<%}else{%>
						    	<%=cha.getCh_before()%>
						    	<%}%>
						    	
						    </td>
						    <td style="font-size : 10pt;" width="20%">
						    	<% ch_after = cha.getCh_after();%> 
						    	<%if(cha.getCh_item().equals("5") && (cha.getCh_after().equals("21세이상")||cha.getCh_after().equals("24세이상")||cha.getCh_after().equals("26세이상")||cha.getCh_after().equals("30세이상")||cha.getCh_after().equals("35세이상")||cha.getCh_after().equals("43세이상")||cha.getCh_after().equals("48세이상"))){%>
						    	만<%=cha.getCh_after()%>
						    	<%}else{%>
						    	<%=cha.getCh_after()%>
						    	<%}%>
						    	
						    </td>
						    <%		}%>
				         </tr>
		               	<%	if(ins_cha_size>1){%>
						<%	for(int j = 1 ; j < ins_cha_size ; j++){
								InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(j);%>
                		<tr bgcolor="#FFFFFF" align="center"  height="30"> 
							<td style="font-size : 10pt;" width="20%" >
								<%if(cha.getCh_item().equals("10")){%>대인2가입금액<%}%>
								<%if(cha.getCh_item().equals("1")){%>대물가입금액<%}%>
								<%if(cha.getCh_item().equals("2")){%>자기신체사고가입금액(사망/장애)<%}%>
								<%if(cha.getCh_item().equals("12")){%>자기신체사고가입금액(부상)<%}%>
								<%if(cha.getCh_item().equals("7")){%>대물+자기신체사고가입금액<%}%>
								<%if(cha.getCh_item().equals("3")){%>무보험차상해특약<%}%>
								<%if(cha.getCh_item().equals("4")){%>자기차량손해가입금액<%}%>
								<%if(cha.getCh_item().equals("9")){%>자기차량손해자기부담금<%}%>
								<%if(cha.getCh_item().equals("5")){%>연령변경<% item = "연령변경";}%>
								<%if(cha.getCh_item().equals("6")){%>애니카특약<%}%>
								<%if(cha.getCh_item().equals("8")){%>차종변경<%}%>
								<%if(cha.getCh_item().equals("11")){%>차량대체<%}%>
								<%if(cha.getCh_item().equals("13")){%>기타<%}%>
								<%if(cha.getCh_item().equals("14")){%>임직원한정운전특약<%}%>
								<%if(cha.getCh_item().equals("15")){%>피보험자변경<%}%>
								<%if(cha.getCh_item().equals("16")){%>고객피보험자 보험갱신<%}%>
								<%if(cha.getCh_item().equals("17")){%>블랙박스<%}%>
								<%if(cha.getCh_item().equals("18")){%>견인고리<%}%>
							</td>
					    	<td style="font-size : 10pt;" width="20%"><%=cha.getCh_before()%></td>
					  		<td style="font-size : 10pt;" width="20%"><%=cha.getCh_after()%></td>	
		                </tr>
						<%	}%>                
		                <%	}%>
		                <%	if(fee_cng>0){%>
		                <tr bgcolor="#FFFFFF" align="center"  height="30">	
						    <td style="font-size : 10pt;" width="20%" >
									대여료(월)
						    </td>
						    <td style="font-size : 10pt;" width="20%"><%=AddUtil.parseDecimal(d_bean.getO_fee_amt())%></td>
						    <td style="font-size : 10pt;" width="20%"><%=AddUtil.parseDecimal(d_bean.getN_fee_amt())%></td>		
						    <%
						     amt_comp = d_bean.getN_fee_amt() - d_bean.getO_fee_amt();
						    %>
						    				
		                </tr>                
		                <%	}%>
		                <% 	}%>
				      
			       	</table>	
			       	<%
			       		if(ins.getCar_use().equals("1") && ch_after.equals("21세이상")){
			       	%>
			       	<div id="tip1">
				       	<p style="margin:2px;font-size:9pt;padding-left:40px; width:640px;">
				       		* 연령 만 21세이상 변경시 추후 차량이용자가 만 26세이상 되면 대여료 인하를 위해 담당자에게 연락하시어 연령상향 요청을 해주시기바랍니다
				       	</p>
			       	</div>
			       	<%
			       		}
			       	%>
    			</div>
    			<div id="con2">
    				<div id="con2Title">
    					<p style="font-size:11pt;display:inline-block;padding:0px 0px 0px 20px;margin-bottom: 5px;" >
    					■ 적용기간 <span  style="font-size:11pt;">(신청고객 기재란)</span>
    					</p>
    				</div>
    				<table width="610" align="center" >
   					   <%	
   							Hashtable f_cont = new Hashtable();
		                	for(int i=0;i < vid_size;i++){
							//보험변경
							InsurChangeBean d_bean = ins_db.getInsChangeDoc(ch_cd[i]);
								
							//보험변경리스트
							Vector ins_cha = ins_db.getInsChangeDocList(ch_cd[i]);
							int ins_cha_size = ins_cha.size();
							
							//계약기본정보
						//	ContBaseBean base = a_db.getCont(d_bean.getRent_mng_id(), d_bean.getRent_l_cd());
							
							//계약조회
							Hashtable cont = as_db.getRentCase(d_bean.getRent_mng_id(), d_bean.getRent_l_cd());
							
							if(i==0) f_cont = cont;
							int cont_dis = 0;
							int fee_cng = 0;
							if(d_bean.getD_fee_amt()>0 || d_bean.getD_fee_amt()<0) fee_cng = 1;
		                %>
                     	<tr bgcolor="#FFFFFF" align="center" > 
		  					<td  rowspan="2" style="font-size : 11pt;" width="150" height="20">개시일자</td>
		                    <td  colspan="2" style="font-size : 11pt;" height="20">종료일자</td>
		                    <td  rowspan="2" style="font-size : 11pt;" width="100" height="20">(미정)선택주의사항</td>		
		                </tr>
		                 <tr bgcolor="#FFFFFF" align="center"> 
		                    <td style="font-size : 11pt;" width="150" height="20">확정일자</td>
		                    <td style="font-size : 11pt;" width="120" height="20">미정</td>		
		               	</tr>
			            <tr bgcolor="#FFFFFF" align="center"  height="100">
					    	<td style="font-size : 11pt;" rowspan=''>20&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;월&nbsp; &nbsp;&nbsp;&nbsp;일 <br/><br/>24시(부터)</td>
					    	<td style="font-size : 11pt;" rowspan=''>20&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;일 <br/><br/>24시(까지)</td>
						    <%	for(int j = 0 ; j < 1 ; j++){
									InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(j);%>
						    	<td style="font-size : 11pt;"  >
							
							    </td>
						   		 <td style="font-size : 10pt; padding-left:30px;" align='left' >
						    		가) 미정 칸에 서명 또는<br/>&nbsp;&nbsp;&nbsp;날인<br/><br/>
						    		나) 원복 할 때는 요청서 <br/>&nbsp;&nbsp;&nbsp;를 재작성해 접수해야<br/>&nbsp;&nbsp;&nbsp;만 합니다<br/>
						   		 </td>
						    <%	}%>
						</tr>
			                <%	if(ins_cha_size>1){%>
							<%		for(int j = 1 ; j < ins_cha_size ; j++){
										InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(j);
									
							%>
							<%		}%>                
			                <%	}%>
			                <%	if(fee_cng>0){%>
			                <%	}%>
			                <% 	}%>
			       	</table>
			       		<div id="tip1">
				       	<p style="margin:2px;font-size:9pt;padding-left:40px; width:640px;">
				       		* 적용기간이 없는 경우 개시일자를 자필로 작성해 주시고, 미정란에 작성자의 서명을  해 주시기 바랍니다. 
				       	</p>
				       	<p style="margin:2px;font-size:9pt;padding-left:40px; width:640px;">
				       		* 개시일자는 필수 기재 항목 입니다.
				       	</p>
			       	</div>
			       	
    			</div>
    			<%if( item.equals("연령변경")  && amt_comp > 0){%>
    			
    				<div id="con3">
    				<div id="con3Title">
    					<p style="font-size:11pt;display:inline-block;padding:0px 0px 0px 20px;margin-bottom: 10px;">
    					■ 최저연령운전자 <span  style="font-size:11pt;">(신청고객 기재란)</span></p>
    				</div>
    				<table width="610" height="60" align="center" >
						<tr bgcolor="#FFFFFF" align="center"> 
							<td style="font-size : 10pt;" width="10%">고객명</td>
							<td style="font-size : 10pt;" width="15%"></td>
							<td style="font-size : 10pt;" width="20%">생년월일</td>		
							<td style="font-size : 10pt;" width="15%"></td>		
							<td style="font-size : 10pt;" width="15%">연락처</td>		
							<td style="font-size : 10pt;" width="15%"></td>		
						</tr>
						 <tr bgcolor="#FFFFFF" align="center"> 
						    <td style="font-size : 10pt;" width="10%">변경사유</td>
							<td style="font-size : 10pt;" width="15%"></td>		
							<td style="font-size : 10pt;" width="20%">계약자와의 관계</td>		
							<td style="font-size : 10pt;" width="15%"></td>		
							<td style="font-size : 10pt;" width="15%">면허취득연도</td>		
							<td style="font-size : 10pt;" width="15%"></td>		
						</tr>
			       	</table>
			       	<div id="tip1">
				       	<p style="margin:2px;font-size:11pt;padding-left:40px; width:640px;">
				       		요청담당자 연락처: 
				       	</p>
				       	<p style="margin:2px;font-size:11pt;padding-left:40px; width:640px;">
				       		모든 보험은 요청하신 개시일자 저녁 12시부터 적용됩니다.
				       	</p>
			       	</div>
    			</div>
    			
    			<%}else{ %>
    				<div style="margin-bottom:150px;"></div>
    			<%} %>
    			<div id="con4">
					<div width="90%"  align="center" style="padding-top:0px;">
						<div>
							<p style="font-size:12pt;padding:10px;">상기와 같이 계약사항의 일부를 변경을 요청합니다.</p>
						</div>
						<div>
							<div style="font-size:12pt;padding:5px;">20&nbsp;&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;일</div>
						</div>
						<div align="right" style="padding:30px 40px 0px 0px;">
							<div style="font-size:12pt;display:inline-block;padding-right:250px;">계약자</div>
							<div style="font-size:10pt;display:inline-block;">(서명/날인)</div>
						</div>
					</div>
				</div>
			</div>
	   		<div id="footer" style="padding-top:30px;"> <!-- 전체 비율 중 하단비율  -->
	   			<div id="fot1">
				<%
	   				String year = "";
	   				String mon = "";
	   				String day = "";
	   				if(r_fee_est_dt != ""){
	   					 year = r_fee_est_dt.substring(0,4);   
	   					 mon = r_fee_est_dt.substring(4,6);   
	   					 day = r_fee_est_dt.substring(6,8);
	   				}
	   			%>
	   			<p style="margin:0px;font-size:11pt;padding:3px;font-family:궁서;">당일 신청 건은 오후 4시전까지 회신부탁드립니다.</p>
	   			<p style="margin:0px;font-size:11pt;padding:3px;font-family:궁서;">그 이후 요청 건은 익일 24시부터 적용됩니다.</p>
	   			
	   			<% if(r_fee_est_dt != ""){ %>
					<p style="margin:0px;font-size:10pt;padding:3px;">다음 결제예정일 : <%=year%>년 <%=mon%>월 <%=day%>일</p>
				<%} %>	
					<p style="margin:0px;font-size:10pt;padding:3px;">1. 변경에 따른 대여료 조정이 있습니다.</p>
					<p style="margin:0px;font-size:10pt;padding:3px;">2. 본 문서 계약자란에 명판과 직인을 날인하고 아래 FAX로 회신해 주십시오.</p>
					<p style="margin:0px;font-size:10pt;padding:3px;">&nbsp;&nbsp;&nbsp;보험담당자 : 고영은 (TEL 02-6263-6372)&nbsp;&nbsp;&nbsp;FAX(보험전용) : 02-6944-8451</p>
				<%
					
					//계약기본정보
					ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
					String bus_id = "";
					if(user_type.equals("1")) bus_id = base.getBus_id2(); //영업담당자
					else if(user_type.equals("2")) bus_id = base.getBus_id();	//최초영업자
					else if(user_type.equals("3")){ //등록자
						bus_id = user_id;
					}
				
					UsersBean bus_bean 	= umd.getUsersBean(bus_id);
				%>	
					<p style="margin:0px;font-size:10pt;padding:3px;">&nbsp;&nbsp;&nbsp;영업담당자 : <%=bus_bean.getUser_nm()%> (TEL <%=bus_bean.getUser_m_tel()%>)</p>
	   			</div>
  			</div>
    	</div>    
	</div>
</form>
</body>
</html>
<script>

</script>