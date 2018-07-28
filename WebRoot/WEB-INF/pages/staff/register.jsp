<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<STYLE>
.cla1 {
FONT-SIZE: 12px; COLOR: #4b4b4b; LINE-HEIGHT: 18px; TEXT-DECORATION: none
}
.login_msg{
	font-family:serif;
}
.login_msg .msg{
	background-color: #acf;
	font-family: 微软雅黑;
}
.login_msg .btn{
	background-color: #9be;
	width: 73px;
	font-size: 18px;
	font-family: 微软雅黑;
}
.register_title{
	font-size: 32px;
	font-family: 微软雅黑;
	color:#02d;
}
.login_msg_field{
	font-family: 微软雅黑;
}
</STYLE>

<TITLE></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<LINK href="${pageContext.request.contextPath}/css/style.css" type=text/css rel=stylesheet>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/easyui.css">  
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/icon.css">  
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>  
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/js/Calendar.js"></script>  
<script>
	$(function(){
		
		//对用户名的校验
		$("#loginName").blur(function(){  //一旦失去焦点就会触发，失去焦点后一定会执行function的内容
			var  name=$(this).val();   //获取或设置value（一般用于带有value属性的标签，比如input）
			if(name==""){
				$("#sp1").text("用户名不能为空");
			}else{
				if(!name.match("[\\w]{4,}")){
					$("#sp1").text("用户名至少4个英文字符或者数字");
				
				}else{
				var flag=true;//只让第一次直接同过这种方式发送请求
				if(flag){
					$.ajax({
						async:true,//异步交互
						url:"/CRM-1/JsonAction_findByName?a="+Math.random(),
						type:"post",
						data:"loginName="+name,
						/* dataType: "json", */  
						success:function(result){
						/* alert(result); */
							var info=eval("("+result+")"); 
							 
						/* 	for(attr in result){
								alert(result[attr]);
								$("#sp1").text(result[attr]);
							}  */
							for(attr in info){
								
								$("#sp1").text(info[attr]);
							/* 	$("#loginName").val("");
								$("#sp1").empty(); */
								
								
							}
						}
						
					}); 
					flag=false;
				}
			
				
				//这里同样是为了解决问题一，这样又出现问题二，会增多对服务器的访问量，要求用的时候要合理
				//还是有一点小问题，就是会如果光标不断的切换，会导致嵌套循环请求服务器
				$("#loginName").focus(function(){
					$("#loginName").bind("input",function(){
						var  name=$(this).val();   //获取或设置value（一般用于带有value属性的标签，比如input）
						$.ajax({
							async:true,//异步交互
							url:"/CRM-1/JsonAction_findByName?a="+Math.random(),
							type:"post",
							data:"loginName="+name,
							/* dataType: "json", */  
							success:function(result){
							/* alert(result); */
								var info=eval("("+result+")"); 
								 
							/* 	for(attr in result){
									alert(result[attr]);
									$("#sp1").text(result[attr]);
								}  */
								for(attr in info){
									
									$("#sp1").text(info[attr]);
								/* 	$("#loginName").val("");
									$("#sp1").empty(); */
									
									
								}
							}
							
						}); 
					});
				})
			 
							
			
				}
			}
		});
		

		
		//对密码的校验
		$("#loginPwd").blur(function(){
			var pwd=$(this).val();
			if(pwd==""){
				$("#sp2").text("密码不能为空");
			}else{
				if(!pwd.match("[\\w]{4,}")){
					$("#sp2").text("密码至少4位");
				}else{
					$("#sp2").text("");
				}
				
				
			}
		});
		//对确认密码的校验
		$("#reloginPwd").blur(function(){
			var pwd=$(this).val();
			if(pwd==""){
				$("#sp3").text("密码不能为空");
			}else{
				if(pwd!=$("#loginPwd").val()){
					$("#sp3").text("请保持两次密码输入一致");
				}else{
					$("#sp3").text("");
				}
				
				//问题一：防止用户通过改密码框而不是修改确认密码框，让两者一致,这里会出现一个问题（包括每个有验证的输入框）：
				//当用户最后来更改有问题的输入框后，这样写，必须在输入完后，必须触发光标失去焦点事件，才会更新验证信息，
				//当用户修改后，直接点击注册，不会触发$("#loginPwd").blur事件,导致用户虽然两次密码相同了，但
				//由于验证信息没有更新，而无法提交注册
				//解决方法：用input或者propertychange事件，实时的动态监听对象的值是否改变
/* 					$("#loginPwd").focus(function(){
						$("#loginPwd").blur(function(){
						if(pwd!=$("#loginPwd").val()){
							$("#sp3").text("请保持两次密码输入一致");
						}else{
							$("#sp3").text("");
						}
					});
				});  */
				
				//上述问题的解决方法bind("input propertychange",function()，bind：绑定，在对象上绑定input 和propertychange事件（替代input在IE9以下的不兼容）
					$("#loginPwd").bind("input propertychange",function(){
						if(pwd!=$("#loginPwd").val()){
							$("#sp3").text("请保持两次密码输入一致");
						}else{
							$("#sp3").text("");
						}
				});
			
			}
		});
	});
	
	//在js的函数（代码中是可以混用jQuery的语法的）
	function submit_register(){
	
		if(($("#sp1").text()=="")&&($("#sp2").text()=="")&&($("#sp3").text()=="")){

		    document.forms[0].submit(); //document.forms[0]:得到所有表单对象的第一个（数组存在形式），将它提交
		}
		
		
	}
</script>
<META content="MSHTML 6.00.2600.0" name=GENERATOR></HEAD>
<BODY leftMargin=0 topMargin=0 marginwidth="0" marginheight="0" background="${pageContext.request.contextPath}/images/rightbg.jpg">
<div ALIGN="center">
	<table border="0" width="1140px" cellspacing="0" cellpadding="0" id="table1">
		<tr>
			<td height="93"></td>
			<td></td>
		</tr>
		<tr>
			<td background="${pageContext.request.contextPath}/images/right.jpg"  width="740" height="412"></td>
			<td class="login_msg" width="400">
				<form class="login_msg_field" action="${pageContext.request.contextPath}/staffAction_register" method="post" enctype="multipart/form-data">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="register_title">新用户注册</span><br/><br/>
					用&nbsp;&nbsp;户&nbsp;&nbsp;名：<input class="msg" type="text" name="loginName" id="loginName">&nbsp;&nbsp;<span id="sp1"></span><br/><br/>
					密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码：<input class="msg" type="password" name="loginPwd" id="loginPwd">&nbsp;&nbsp;<span id="sp2"></span><br/><br/>
					确认密码：<input class="msg" type="password" id="reloginPwd">&nbsp;&nbsp;<span id="sp3"></span><br/><br/>
					姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名：<input class="msg" type="text" name="staffName"><br/><br/>
					性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别：<select class="msg" name="gender">
					<option>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;男</option>
					<option>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;女</option>
					</select><br/><br/>
					<!-- 出生日期：<input id="dd" type="text" class="easyui-datebox" required="required" name="birthday"></input><br/><br/> -->
					出生日期：<input type="text" class="msg" name="birthday"/><br/><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input class="btn" type="button" value=" 注册 " id="btn1" onclick="submit_register()"/>
					
					<input class="btn" type="button" value=" 取消 " onclick="document.location='${pageContext.request.contextPath}'"/>
					
				</form>
			</td>
		</tr>
	</table>
</div>
</BODY></HTML>